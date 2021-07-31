import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditPost extends StatefulWidget {
  final Map data;
  EditPost({this.data});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String imagePath;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.data["title"];
    descriptionController.text = widget.data["description"];
  }

  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image.path;
      });
      print(imagePath);
    }

    void done() async {
      try {
        String imageName = path.basename(imagePath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String donwnloadUrl = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;

        Map<String, dynamic> newPost = {
          "title": titleController.text,
          "description": descriptionController.text,
          "url": donwnloadUrl,
        };

        await db.collection("posts").doc(widget.data["id"]).set(newPost);
        Navigator.of(context).pop();
      } catch (e) {
        print(e.message);
      }
    }

    return AlertDialog(
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: UnderlineInputBorder(),
                labelText: 'Enter title'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: UnderlineInputBorder(),
                labelText: 'Enter description'),
          ),
          ElevatedButton(onPressed: pickImage, child: Text("Pick an image")),
          ElevatedButton(onPressed: done, child: Text("Done")),
        ],
      )),
    );
  }
}

// class EditPost extends StatefulWidget {
  
//   @override
//   _EditPostState createState() => _EditPostState();
// }

// class _EditPostState extends State<EditPost> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController titleController =
//         TextEditingController(text: data["text"]);
//     TextEditingController descriptionController = TextEditingController();

//     void pickImage() {}

//     void done() {}

//     return AlertDialog(
//       content: Container(
//           child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextFormField(
//             controller: titleController,
//             decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(10.0),
//                 border: UnderlineInputBorder(),
//                 labelText: 'Enter title'),
//           ),
//           TextFormField(
//             controller: descriptionController,
//             decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(10.0),
//                 border: UnderlineInputBorder(),
//                 labelText: 'Enter description'),
//           ),
//           ElevatedButton(onPressed: pickImage, child: Text("Pick an image")),
//           ElevatedButton(onPressed: done, child: Text("Done")),
//         ],
//       )),
//     );
//   }
// }
