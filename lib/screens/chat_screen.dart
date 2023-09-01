import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

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
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: TextFieldBuilder(
                    hintText: '',
                    onChanged: (value) {},
                    decoration: kMessageTextFieldDecoration,
                  )),
                  FilledButton(
                    onPressed: () {
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

// TextField(
// onChanged: (value) {
// //Do something with the user input.
// },
// decoration: kMessageTextFieldDecoration,
// ),
// )
