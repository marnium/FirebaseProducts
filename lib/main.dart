import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:productos/home/Home.dart';
import 'package:productos/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? Home(
              user: FirebaseAuth.instance.currentUser,
            )
          : Login(),
    );
  }
}
