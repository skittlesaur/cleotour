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
        backgroundColor: Colors.black,
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
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[800],
                              hintText: 'What\'s new?',
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber))),
                          controller: _postBodyController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[800],
                              hintText: 'Location',
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber))),
                          controller: _locationController,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        ImageInput(setImage: setImage),
                        SizedBox(
                          height: 150,
                        ),
                        Container(
                            color: Colors.amber,
                            alignment: Alignment.bottomCenter,
                            width: 320,
                            child: SizedBox(
                                height: 50,
                                width: 275,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                      color: Colors.amber,
                                      width: 1,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_postBodyController.text.isEmpty ||
                                        _locationController.text.isEmpty ||
                                        imagePath == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please fill in all fields and upload an image.'),
                                        ),
                                      );
                                    } else {
                                      await uploadPost(imagePath);
                                      setState(() {
                                        _postBodyController.text = '';
                                        _locationController.text = '';
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Post',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))) /////
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
