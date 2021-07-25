import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: "GhulamQadirSakaria25@gmail.com");
    final TextEditingController passwordController =
        TextEditingController(text: "Sakaria</>2125");

    void login() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        final DocumentSnapshot snapshot =
            await db.collection("users").doc(user.user.uid).get();
        final data = snapshot.data();

        Navigator.of(context).pushNamed("/home");
        print("User is logged in");
      } catch (e) {
        print("Error occured");
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        // appBar: AppBar(
        //   title: Center(child: Text("LOGIN PAGE")),
        //   backgroundColor: Colors.brown,
        // ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 80,
                ),
                Container(
                  child: Text(
                    "Registration Form",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: 250,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red[100],
                            ),
                            borderRadius: BorderRadius.circular(17)),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 250,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white30,
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    color: Colors.greenAccent,
                    child: ElevatedButton(
                      onPressed: login,
                      child: Text("Login"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
