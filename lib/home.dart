import 'package:flutter/material.dart';
import 'package:flutterfirebase/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Stream postStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: postStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          // Map<String, dynamic> data = document.data();
                          return Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcbomyDPaMuQA7Ts_ZCDxDiXnqkGHmH5gSKwb2Ky4n9gi3aRqPUGbJBSHSFvwPWmVOF2k&usqp=CAU",
                                  height: 200,
                                  width: 200,
                                ),
                                Text("Car"),
                                Text("Imported from Canada")
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ],
          ),
        )));
  }
}
