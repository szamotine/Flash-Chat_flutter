import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../components/rounded_button_builder.dart';
import '../components/text_field_builder.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                hintText: 'Enter your password',
                onChanged: (value) {
                  //Do something with the user input.
                }),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButtonBuilder(
                title: 'Register',
                onPressed: () {
                  //Implement registration functionality.
                },
                color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
