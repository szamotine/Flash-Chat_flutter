import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/message.dart';
import '../components/text_field_builder.dart';

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
      print('Error in ChatScreen.getCurrentUser(): $e');
    }
  }

  Future<void> getMessages() async {
    final messages = await _firestore.collection(collectionPath).get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  Future<void> messagesStream() async {
    await for (var snapshot in stream!) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                final messages = snapshot.data?.docs;
                List<Text> messageWidgets = [];
                List<Message> messageList = [];

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
                    final messageWidget = Text('${m.messageTimeStamp} \t ${m.sender}: \t\t${m.message}');
                    messageWidgets.add(messageWidget);
                  }
                }

                return Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: messageWidgets,
                  ),
                );
              },
            ),
            Expanded(
              child: Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: TextFieldBuilder(
                      textEditingController: textEditingController,
                      textStyle: kTextFieldChatInputTextStyle,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      hintText: '',
                    )),
                    FilledButton(
                      onPressed: () {
                        //Implement send functionality.
                        _firestore.collection(collectionPath).add({
                          textField: messageText,
                          senderField: loggedInUser.email,
                          timeField: Timestamp.now(),
                        });
                        textEditingController.clear();
                      },
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                    // FilledButton(
                    //   onPressed: () {
                    //     messagesStream();
                    //   },
                    //   child: Text('Get messages'),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
