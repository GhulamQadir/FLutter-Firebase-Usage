import 'package:flutter/material.dart';
import 'package:flutterfirebase/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleCOntroller = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Stream postStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    void pickimage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);
      print(image.openRead());
    }

    void submit() {
      String title = titleCOntroller.text;
      String description = descriptionController.text;

      print("Title is: $title");
      print("Description is: $description");
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  controller: titleCOntroller,
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
                  onPressed: pickimage, child: Text("Pick an image")),
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
                            return SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Column(
                                  children: <Widget>[
                                    Text("Owner: ${data["username"]}"),
                                    Image.network(
                                      data["url"],
                                      height: 150,
                                      width: 150,
                                    ),
                                    Text(data["title"] ?? ''),
                                    Text(data["description"] ?? '')
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
