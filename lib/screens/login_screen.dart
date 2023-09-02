import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/alert_dialogue.dart';
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
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  late bool showSpinner = false;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

  void setSpinner() {
    setState(() {
      showSpinner ? showSpinner = false : showSpinner = true;
    });
  }

  Future<void> validateLogin() async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        setSpinner();
        UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final String? userEmail = userCred.user?.email;
        setSpinner();
        showLoginDialogue('$kLoginSuccessful : $userEmail');
      } else if (email.isEmpty) {
        showLoginDialogue('Please enter an email address');
      } else if (password.isEmpty) {
        showLoginDialogue('Please enter a password');
      }
    } on FirebaseAuthException catch (e) {
      showLoginDialogue('$kLoginUnsuccessful: \n Error: ${e.code} \n ${e.message}');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
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
                  textEditingController: textEditingController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  }),
              const SizedBox(
                height: 8.0,
              ),
              TextFieldBuilder(
                textEditingController: textEditingController2,
                hintText: 'Enter your password.',
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButtonBuilder(
                  title: 'Log In',
                  onPressed: () {
                    validateLogin();
                    Navigator.pushNamed(context, ChatScreen.id);
                  },
                  color: Colors.lightBlueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
