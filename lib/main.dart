import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_it/screens/logo_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/gps_screen.dart';
import 'screens/loading_screen.dart';
import 'database/data_transferer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "navbus",
      options: const FirebaseOptions(
          apiKey: "AIzaSyBQfNdXFkkIRwc0RP-JLSysKPvSKRe2o3E ",
          appId: "1:476515452163:android:2d1bce606608c65e291536",
          messagingSenderId: "476515452163 ",
          projectId: "navbus-2d528"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransferData>(
      create: (context) => TransferData(),
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: LoadingScreen.id,
        routes: {
          LogoScreen.id: (context) => LogoScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          LoadingScreen.id: (context) => LoadingScreen(),
          GpsScreen.id: (context) => GpsScreen(),
        },
      ),
    );
  }
}
