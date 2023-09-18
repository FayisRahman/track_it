import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/widgets/textfield.dart';
import 'package:track_it/widgets/text_button.dart';
import 'package:track_it/widgets/loader.dart';

import 'loading_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _cloud = FirebaseFirestore.instance;
  String? _userName;
  bool isError = false;
  bool? _checkState = false;
  late SharedPreferences _prefs;

  void getInstance() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Image(
                  image: AssetImage('images/bus.png'),
                  height: 70,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Create Account",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 35,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TxtField(
                title: "First Name",
                onChanged: (value) {
                  _userName = value;
                },
                isError: isError,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Checkbox(
                      value: _checkState,
                      onChanged: (newValue) {
                        setState(() {
                          _checkState = newValue;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const Text(
                    "I accept the Terms and Conditions",
                    style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Center(
                child: Column(
                  children: [
                    TxtButton(
                        title: "Create account",
                        isChecked: _checkState!,
                        onPressed: () async {
                          //to register
                          if (_checkState!) {
                            _userName?.toLowerCase();
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return const Loader();
                                });
                            _userName?.toLowerCase();
                            try {
                              //adding ur username and pass in database
                              await _auth.createUserWithEmailAndPassword(
                                  email:
                                      "${_userName?.replaceAll(" ", "")}@gmail.com",
                                  password: "1234567");
                              await _auth.currentUser
                                  ?.updateDisplayName("$_userName");
                              await _prefs.setString(
                                  'userName', _userName!.replaceAll(" ", ""));
                              await _prefs.setBool('isLoggedIn', true);
                              isError = false;
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    LoadingScreen.id, (route) => false);
                              }
                            } catch (e) {
                              isError = true;
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              print(e);
                            }
                          } else {}
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 3,
                          color: Colors.white54,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text("or"),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 3,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TxtButton(
                        title: "Log In as a guest user",
                        onPressed: () async {
                          //to register
                          // showDialog(
                          //     barrierDismissible: false,
                          //     context: context,
                          //     builder: (context) {
                          //       return const Loader();
                          //     });
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, LoadingScreen.id, (route) => false);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// try {
// //adding ur username and pass in database
// await _auth.createUserWithEmailAndPassword(
// email:
// "${_userName?.replaceAll(" ", "")}@gmail.com",
// password: "1234567");
// await _auth.currentUser
//     ?.updateDisplayName("$_userName");
// await _prefs.setString(
// 'userName', _userName!.replaceAll(" ", ""));
// await _prefs.setBool('isLoggedIn', true);
// isError = false;
// if (context.mounted) {
// Navigator.pushNamedAndRemoveUntil(
// context, LoadingScreen.id, (route) => false);
// }
// } catch (e) {
// isError = true;
// if (context.mounted) {
// Navigator.pop(context);
// }
// print(e);
// }
