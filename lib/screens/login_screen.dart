import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'registration_screen.dart';
import '../widgets/loader.dart';
import '../widgets/text_button.dart';
import '../widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login Screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final SharedPreferences _prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userName;
  bool? isError = false;
  String? loggedUser;
  bool? isLoggedIn = false;

  void prefInitialiser() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    prefInitialiser();
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
                "Hi, Welcome Back!",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 35,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(height: 10),
              TxtField(
                title: "Username",
                onChanged: (value) {
                  _userName = value;
                },
                isError: isError!,
              ),
              const SizedBox(
                height: 35,
              ),
              Center(
                child: Column(
                  children: [
                    TxtButton(
                        title: "Log in",
                        onPressed: () async {
                          _userName =
                              _userName?.toLowerCase().replaceAll(" ", "");
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const Loader();
                              });
                          try {
                            await _auth.signInWithEmailAndPassword(
                                email: "${_userName}@gmail.com",
                                password: "1234567");
                            setState(() {
                              isError = false;
                            });
                            //add the loginstate and username in memory cache
                            //to autologin when opening up the app
                            await _prefs.setBool('isLoggedIn', true);
                            await _prefs.setString('userName', _userName!);
                            print("stored");
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, LoadingScreen.id, (route) => false);
                            }
                          } catch (e) {
                            print(e);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            setState(() {
                              isError = true;
                            });
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("New User?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RegistrationScreen.id, (route) => false);
                            },
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              padding: const EdgeInsets.all(3),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 0.3),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.blue,
                                width: 1, // Underline thickness
                              ))),
                              child: const Text(
                                "Try for free!",
                                style: TextStyle(letterSpacing: 0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
