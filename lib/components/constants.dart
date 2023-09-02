import 'package:flutter/material.dart';

//#region String Constants
const kHeroTagLogo = 'logo';
const kImagesLogoPath = 'images/logo.png';
const String kLoginSuccessful = 'Login Successful';
const String kLoginUnsuccessful = 'Login unsuccessful, try again';

const String kRegistrationSuccessful = 'Registration Successful';
const String kRegistrationUnsuccessful = 'Registration unsuccessful, try again';
//#endregion

const kDrawerListTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const kWelcomePageTextStyle = TextStyle(
  fontSize: 45.0,
  fontWeight: FontWeight.w900,
  color: Colors.black,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldInputTextStyle = TextStyle(
  color: Colors.black,
);

const kTextFieldChatInputTextStyle = TextStyle(
  color: Colors.white,
);
