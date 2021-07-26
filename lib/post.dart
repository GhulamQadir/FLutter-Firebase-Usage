import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
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
        )),
      ),
    );
  }
}
