import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

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

  @override
  void initState() {
    super.initState();
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
        // print(status); // End of animation is "complete", beginning of animation is "dismissed" when playing in reverse
      },
    );
    controller.addListener(() {
      setState(() {});
      //print(controller.value);
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    //Go to login screen.
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
