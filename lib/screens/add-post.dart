// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cleotour/widgets/add-post/image-input.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';
import 'package:cleotour/widgets/common/alertDialogWidget.dart';

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

  var categoryValue = "Museum";
  dynamic user = Auth().getCurrentUser();
  dynamic id = Auth().getCurrentUser()?.uid;

  void setImage(String imagePath2) {
    setState(() {
      imagePath = imagePath2;
    });
  }

  Future uploadPost(String? imagePath) async {
    if (imagePath != null) {
      final uuid = Uuid();
      final ref = _storage.ref().child('images/${uuid.v4()}');
      String imageUrl = ref.fullPath;

      var newDocRef = await _postsCollection.doc();

      await newDocRef.set({
        'postId': newDocRef.id,
        'posterId': Auth().getCurrentUser()?.uid,
        'posterUserName': Auth().getCurrentUser()?.displayName,
        'body': _postBodyController.text,
        'postedAt': DateTime.now().toLocal().toString(),
        'location': _locationController.text,
        'imageUrl': imageUrl,
        'likes': 0,
        'category': categoryValue
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<String>(
                        value: categoryValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            categoryValue = newValue!;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24.0,
                        elevation: 16,
                        underline: SizedBox(),
                        items: ['Beach', 'Club', 'Museum', 'Restaurant']
                            .map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                      ),
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
                        if (id == null || user == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogWidget(title: "You are not signed in", content: "Please sign in to be able to add a post");
                            },
                          );
                          return;
                        } else if (_postBodyController.text.isEmpty ||
                            _locationController.text.isEmpty ||
                            imagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
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