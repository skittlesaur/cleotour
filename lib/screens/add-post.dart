// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cleotour/widgets/add-post/image-input.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? imagePath;
  final _storage = FirebaseStorage.instance;
  final _postsCollection = FirebaseFirestore.instance.collection('Posts');

  final _postBodyController = TextEditingController();
  final _locationController = TextEditingController();

  void setImage(String imagePath2) {
    setState(() {
      imagePath = imagePath2;
    });
  }

  Future uploadPost(String? imagePath) async {
    print(imagePath);
    if (imagePath != null) {
      final uuid = Uuid();
      final ref = _storage.ref().child('images/${uuid.v4()}');
      String imageUrl = ref.fullPath;
      final uploadTask = ref.putFile(File(imagePath));

      var newDocRef = await _postsCollection.doc();

      await newDocRef.set({
        'id': newDocRef.id,
        'body': _postBodyController.text,
        'postedAt': DateTime.now().toLocal().toString(),
        'location': _locationController.text,
        'imageUrl': imageUrl,
        'likes': 0,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'What\'s new?',
                          border: OutlineInputBorder()),
                      controller: _postBodyController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Location', border: OutlineInputBorder()),
                      controller: _locationController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(setImage: setImage),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await uploadPost(imagePath);
                        setState(() {
                          _postBodyController.text = '';
                          _locationController.text = '';
                        });
                      },
                      color: Color.fromRGBO(255, 220, 115, 1),
                      child: Text(
                        'Post',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
