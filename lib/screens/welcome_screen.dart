import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/components/rounded_button_builder.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  // for single animations:   SingleTickerProviderStateMixin
  // for multiple:            TickerProviderStateMixin
  late AnimationController controller;
  late Animation animation;

  late AnimationController controller2;
  late Animation animation2;

  Future<void> initialiseFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Empty on purpose for now
    }
  }

  @override
  void initState() {
    super.initState();
    initialiseFirebase();

    //#region Curved Animation
    controller = AnimationController(
      vsync: this,
      //upperBound: 100, // has to be taken out if using curves
      duration: const Duration(milliseconds: 1500),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    controller.forward(); // controller.reverse(from: value) if you want the animation backwards from value

    animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          controller.reverse(from: 1.0);
        } else if (status == AnimationStatus.dismissed) {
          controller.forward(from: 0.0);
        }
      },
    );
    controller.addListener(() {
      setState(() {});
    });
//#endregion Curved Animation

    //#region Tween Animation

    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animation2 = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller2);
    controller2.forward();
    controller2.addListener(() {
      setState(() {});
    });

    animation2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller2.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller2.forward(from: 0.0);
      }
    });

    //#endregion Tween Animation
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation2.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: kHeroTagLogo,
                  child: SizedBox(
                    height: 60.0 * animation.value,
                    child: Image.asset(kImagesLogoPath),
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(controller.value),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButtonBuilder(
                title: 'Log In',
                onPressed: () {
                  //Go to login screen.
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                color: Colors.lightBlueAccent),
            RoundedButtonBuilder(
                title: 'Register',
                onPressed: () {
                  //Go to registration screen.
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
