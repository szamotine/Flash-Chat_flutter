import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/constants.dart';
import 'package:flash_chat/components/custom_message_bar.dart';
import 'package:flash_chat/components/message_stream_builder.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../components/alert_dialogue.dart';

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

  late DateChip previousDate = DateChip(date: DateTime(2005));

  //TODO: Implement Firebase Messaging for Notifications
  // String messageTitle = "Empty";
  // String notificationAlert = "alert";
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
      // Empty on purpose for now
    }
  }

  void showLoginDialogue(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoginAlertBox(successMessage: message);
        });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                showLoginDialogue(kLogOutSuccessful);
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
            MessageStreamBuilder(
              stream: stream,
              loggedInUser: loggedInUser,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CustomMessageBar(
                messageBarHintStyle: kMessageBarHintStyleTextStyle,
                onSend: (string) {
                  var data = {
                    textField: string,
                    senderField: loggedInUser.email,
                    timeField: Timestamp.now(),
                  };

                  _firestore.collection(collectionPath).add(data);
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
