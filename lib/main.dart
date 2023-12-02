import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/welcome_screen.dart';

void main() async {
  // to link this app with the firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAlaNlKcCth1u0E7NeOaKSOYtb1ZWaJNbw",
      appId: "1:787203328558:android:99e39ee88f0706e820edbf",
      messagingSenderId: "787203328558",
      projectId: "chatapp2-4d624",
    ),
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
