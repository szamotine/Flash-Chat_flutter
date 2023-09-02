import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/constants.dart';
import 'package:flash_chat/components/custom_message_bar.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const id = 'chat_screen';
  static const String kChatText = '⚡️Chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;
  final String collectionPath = 'messages';
  final String senderField = 'sender';
  final String textField = 'text';
  final String timeField = 'timeStamp';
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Object?>>? stream = _firestore.collection(collectionPath).snapshots();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late bool initFlag = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      //print('Error in ChatScreen.getCurrentUser(): $e');
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
          duration: const Duration(seconds: 1), curve: Curves.decelerate);
    }
  }

  bool isSender(String email) {
    bool result = false;

    if (email == loggedInUser.email) {
      result = true;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                //Implement logout functionality
              }),
        ],
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              ChatScreen.kChatText,
              textStyle: const TextStyle(),
              speed: const Duration(milliseconds: 100),
            ),
            TypewriterAnimatedText(
              loggedInUser.email ?? 'User not found',
              textStyle: const TextStyle(),
              speed: const Duration(milliseconds: 100),
            )
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                List<Message> messageList = [];
                List<Widget> bubbleList = [];
                late DateChip previousDate;

                final messages = snapshot.data?.docs;

                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

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

                  for (var m in messageList) {
                    final bubbleWidget = BubbleNormal(
                      text: m.message,
                      isSender: isSender(m.sender),
                      color: isSender(m.sender) ? Colors.green.shade600 : const Color(0xFF1B97F3),
                      tail: true,
                      textStyle: kSendButtonTextStyle,
                    );

                    final dateChip = DateChip(date: m.dateTime);
                    if (initFlag) {
                      print('Init flag in conditional: $initFlag');
                      previousDate = dateChip;
                      initFlag = false;
                    }
                    bubbleList.add(bubbleWidget);

                    try {
                      if (previousDate != null) {
                        int index = previousDate.date.compareTo(dateChip.date);
                        if (index >= 0) {
                          bubbleList.add(dateChip);
                        }
                      }
                    } catch (e) {
                      print('\n\n\n------------$e------------\n\n\n');
                      previousDate = dateChip;
                    }
                  }
                }

                scrollToBottom();

                return Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: bubbleList,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CustomMessageBar(
                messageBarHintStyle: TextStyle(color: Colors.blueGrey),
                onSend: (string) {
                  _firestore.collection(collectionPath).add({
                    textField: string,
                    senderField: loggedInUser.email,
                    timeField: Timestamp.now(),
                  });
                  scrollToBottom();
                  // textEditingController.clear();
                },
                actions: [
                  InkWell(
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
