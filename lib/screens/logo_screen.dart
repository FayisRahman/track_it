import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'loading_screen.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'package:track_it/database/data_transferer.dart';

class LogoScreen extends StatefulWidget {
  static const String id = "LogoScreen";

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  late final SharedPreferences _prefs;
  String? loggedUser;
  bool? isLoggedIn = false;

  void getCache() async {
    //getting login info
    await Provider.of<TransferData>(context, listen: false)
        .initializeSharedPref();
    _prefs = Provider.of<TransferData>(context, listen: false).prefs;
    loggedUser = _prefs.getString("userName") ?? "";
    isLoggedIn = _prefs.getBool("isLoggedIn") ?? false;
    if (context.mounted) {
      if (isLoggedIn!) {
        Navigator.pushNamedAndRemoveUntil(
            context, LoadingScreen.id, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.id, (route) => false);
      }
    }
  }

  @override
  void initState() {
    getCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWaveSpinner(
              color: Colors.blue[700]!,
              waveColor: Colors.blue,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Fetching Data..Please be patient"),
          ],
        ),
      ),
    );
  }
}
