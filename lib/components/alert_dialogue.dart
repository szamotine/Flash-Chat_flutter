import 'package:flutter/material.dart';

import 'constants.dart';

class LoginAlertBox extends StatelessWidget {
  const LoginAlertBox({super.key, required this.successMessage});

  final String successMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Center(
          child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: kDrawerListTextStyle,
              )),
        )
      ],
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              successMessage,
              textAlign: TextAlign.center,
              style: kDrawerListTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
