import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class OldUser extends StatelessWidget {
  const OldUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already have an account?"),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
            style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                padding: const EdgeInsets.all(3),
                minimumSize: Size.zero),
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 0.3,
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.blue,
                width: 1, // Underline thickness
              ))),
              child: const Text(
                "Sign in",
                style: TextStyle(letterSpacing: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
