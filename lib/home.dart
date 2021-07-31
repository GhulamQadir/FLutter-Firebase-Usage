import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutterfirebase/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfirebase/editPost.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String imagePath;

  Stream postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image.path;
      });
      print(imagePath);
    }

    void submit() async {
      try {
        String title = titleController.text;
        String description = descriptionController.text;

        String imageName = path.basename(imagePath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String donwnloadUrl = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").add({
          "title": title,
          "description": description,
          "url": donwnloadUrl,
        });
        print("Post uploaded successfully");
        titleController.clear();
        descriptionController.clear();
      } catch (e) {
        print(e.message);
      }
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(),
                      labelText: 'Enter title'),
                ),
              ),
              Container(
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(),
                      labelText: 'Enter description'),
                ),
              ),
              ElevatedButton(
                  onPressed: pickImage, child: Text("Pick an image")),
              ElevatedButton(onPressed: submit, child: Text("Submit post")),
              Container(
                child: StreamBuilder<QuerySnapshot>(
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
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            Map data = document.data();
                            String id = document.id;
                            data["id"] = id;

                            void deletePost() async {
                              try {
                                FirebaseFirestore db =
                                    FirebaseFirestore.instance;
                                await db
                                    .collection("posts")
                                    .doc(data["id"])
                                    .delete();
                              } catch (e) {
                                print(e.message);
                              }
                            }

                            void editPost() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditPost(data: data);
                                  });
                            }

                            return SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Column(
                                  children: <Widget>[
                                    // Text("Owner: ${data["username"]}"),
                                    Image.network(
                                      data["url"],
                                      height: 150,
                                      width: 150,
                                    ),
                                    Text(data["title"] ?? ''),
                                    Text(data["description"] ?? ''),
                                    ElevatedButton(
                                        onPressed: editPost,
                                        child: Text("Edit")),
                                    ElevatedButton(
                                        onPressed: deletePost,
                                        child: Text("Delete")),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )));
  }
}
