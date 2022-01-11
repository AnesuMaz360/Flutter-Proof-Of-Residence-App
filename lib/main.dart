import 'package:e_proof_app/homepage.dart';
import 'package:e_proof_app/loginpage.dart';
import 'package:e_proof_app/resetpage.dart';
import 'package:e_proof_app/signuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'phoneformpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/phoneform': (context) => PhoneFormPage(),
        '/home': (context) => HomePage(),
        '/resetpage': (context) => ResetPage(),
      },
    );
  }
}
