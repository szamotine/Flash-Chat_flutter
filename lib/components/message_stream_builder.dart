import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'custom_message_bubble.dart';
import 'message.dart';

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key, required this.stream, required this.loggedInUser, required this.scrollController});

  final Stream<QuerySnapshot<Object?>>? stream;
  final String collectionPath = 'messages';
  final String senderField = 'sender';
  final String textField = 'text';
  final String timeField = 'timeStamp';
  final User loggedInUser;
  final ScrollController scrollController;

  bool isSender(String email) {
    bool result = false;

    if (email == loggedInUser.email) {
      result = true;
    }

    return result;
  }

  void scrollToBottom() {
    print('$filler Scrolling to bottom in message stream builder $filler');
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
          duration: const Duration(seconds: 1), curve: Curves.decelerate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        List<Message> messageList = [];
        List<Widget> customBubbleList = [];

        if (snapshot.hasData) {
          // print('$filler snapshot has data');
          final messages = snapshot.data?.docs;

          if (messages != null) {
            for (var message in messages) {
              final messageData = message.data() as Map;

              final Message m =
                  Message(message: messageData[textField], sender: messageData[senderField], timeStamp: messageData[timeField]);
              m.dateTime = m.timeStamp.toDate();
              m.messageTimeStamp = DateFormat('yyyy-MM-dd kk:mm').format(m.dateTime);
              messageList.add(m);
            }
            messageList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
            // print('$filler Message List completed with ${messageList.length} entries $filler');

            for (var m in messageList) {
              final customBubble = CustomMessageBubble(
                sender: m.sender,
                text: m.message,
                isSender: isSender(m.sender),
                timeStamp: m.dateTime,
              );

              customBubbleList.add(customBubble);
            }
          }
          scrollToBottom();
        } else {
          print('$filler snapshot has no data $filler');
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        return Expanded(
          flex: 6,
          child: ListView(
            padding: const EdgeInsets.all(5),
            children: customBubbleList,
            controller: scrollController,
          ),
        );
      },
    );
  }
}
