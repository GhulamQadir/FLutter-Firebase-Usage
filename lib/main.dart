import 'package:flutter/material.dart';
import 'package:flutterfirebase/SignUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfirebase/Login.dart';
import 'package:flutterfirebase/Home.dart';
import 'package:flutterfirebase/post.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: Text("Something went wrong!"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Login(),
            routes: {
              "/login": (context) => Login(),
              "/signup": (context) => SignUp(),
              "/home": (context) => Home(),
              "/post": (context) => Post(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          child: Text("Loading..."),
        );
      },
    );
  }
}
