import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../components/rounded_button_builder.dart';
import '../components/text_field_builder.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: kHeroTagLogo,
              child: SizedBox(
                height: 200.0,
                child: Image.asset(kImagesLogoPath),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextFieldBuilder(
                hintText: 'Enter your email',
                onChanged: (value) {
                  //Do something with the user input.
                }),
            const SizedBox(
              height: 8.0,
            ),
            TextFieldBuilder(
              hintText: 'Enter your password.',
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButtonBuilder(
                title: 'Log In',
                onPressed: () {
                  //Implement login functionality.
                  Navigator.pushNamed(context, ChatScreen.id);
                },
                color: Colors.lightBlueAccent),
          ],
        ),
      ),
    );
  }
}
