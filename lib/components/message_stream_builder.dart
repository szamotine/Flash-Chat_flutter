import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_message_bubble.dart';
import 'message.dart';

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key, required this.stream, required this.loggedInUser});

  final Stream<QuerySnapshot<Object?>>? stream;
  final String collectionPath = 'messages';
  final String senderField = 'sender';
  final String textField = 'text';
  final String timeField = 'timeStamp';
  final User loggedInUser;
  //final ScrollController scrollController;

  bool isSender(String email) {
    bool result = false;

    if (email == loggedInUser.email) {
      result = true;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        List<Message> messageList = [];
        List<Widget> customBubbleList = [];

        if (snapshot.hasData) {
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

            messageList = messageList.reversed.toList();

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
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        return Expanded(
          flex: 6,
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.all(5),
            children: customBubbleList,
          ),
        );
      },
    );
  }
}
