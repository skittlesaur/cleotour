import 'package:cleotour/auth.dart';
import 'package:cleotour/widgets/common/alertDialogWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../notifications/notification_service.dart';

class AddPost extends StatefulWidget {
  Function changeAddingPost;

  AddPost({required this.changeAddingPost});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPost> {
  User? currentUser = Auth().getCurrentUser();

  int _currentStep = 0;
  bool _isPosting = false;
  File? _image;
  final _storage = FirebaseStorage.instance;
  final _postsCollection = FirebaseFirestore.instance.collection('Posts');

  final _postBodyController = TextEditingController();
  final _locationController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {
      "name": "Museum",
      "icon": Icons.museum,
    },
    {
      "name": "Restaurant",
      "icon": Icons.restaurant,
    },
    {
      "name": "Hotel",
      "icon": Icons.hotel,
    },
    {
      "name": "Park",
      "icon": Icons.park,
    },
    {
      "name": "Beach",
      "icon": Icons.beach_access,
    },
    {
      "name": "Other",
      "icon": Icons.more_horiz,
    },
  ];

  Map<String, dynamic> _selectedCategory = {};

  Future getImages(bool gallery) async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: (gallery) ? ImageSource.gallery : ImageSource.camera,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future uploadPost() async {
    final uuid = Uuid();
    final ref = _storage.ref().child('images/${uuid.v4()}');
    await ref.putFile(_image!);
    String imageUrl = await ref.getDownloadURL();

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
      'averageRating': '0',
      'category': _selectedCategory['name']
    });

    setState(() {
      _isPosting = false;
    });
    widget.changeAddingPost(false);
  }

  void nextStep() {
    if (_isPosting) {
      return;
    }
    if (_currentStep == 0) {
      // image upload validation
      if (_image == null || _image?.path == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogWidget(
              title: "No image selected",
              content: "Please select an image to continue",
            );
          },
        );

        return;
      }
    } else if (_currentStep == 1) {
      // caption and location validation
      if (_postBodyController.text.isEmpty ||
          _locationController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogWidget(
              title: "Missing fields",
              content: "Please fill all the fields to continue",
            );
          },
        );

        return;
      }
    } else if (_currentStep == 2) {
      // category validation and upload post
      if (_selectedCategory.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogWidget(
              title: "Missing fields",
              content: "Please select a category to continue",
            );
          },
        );

        return;
      }
      setState(() {
        _isPosting = true;
      });
      uploadPost();
      NotificationService().showNotification(title: 'Post Uploaded');

      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentStep == 0
                    ? Container(
                        width: 20,
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ),
                Text(
                  "Add a new post",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    nextStep();
                  },
                  child: Text(
                    _currentStep == 2 ? "Post" : "Next",
                    style: TextStyle(
                        fontSize: 16,
                        color: _currentStep == 2
                            ? Color(0xffffbf00)
                            : Colors.grey[400]),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // selected image
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[800]!),
              ),
              clipBehavior: Clip.hardEdge,
              child: _image == null
                  ? Center(
                      child: Text(
                        "No image selected",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )
                  : Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
              // : Image.network(
              //     "https://images.unsplash.com/photo-1662010021854-e67c538ea7a9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=952&q=80",
              //     fit: BoxFit.cover,
              //   ),
            ),
            SizedBox(
              height: 10,
            ),
            _currentStep != 2
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // post body
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: (currentUser!.photoURL != null)
                                ? NetworkImage(currentUser!.photoURL!)
                                : AssetImage('assets/avatardefault.png')
                                    as ImageProvider<Object>?,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser!.displayName!,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[400]),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[400],
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    _locationController.text,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  _postBodyController.text,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  maxLines: 3,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
            Divider(
              color: Colors.grey[800],
            ),
            SizedBox(
              height: 10,
            ),
            // steps
            getCurrentStep(),
          ])),
        ),
      ),
    );
  }

  Widget getCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Step0();
      case 1:
        return Step1();
      case 2:
        return Step2();
      default:
        return Container();
    }
  }

  Widget Step0() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Image",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () async {
                  await getImages(true);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Upload from gallery",
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await getImages(false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Take a photo",
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Step1() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Caption",
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _postBodyController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _locationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Add a location...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Step2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick a category",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < _categories.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = _categories[i];
                      });
                    },
                    child: Container(
                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _selectedCategory == _categories[i]
                            ? Color(0xffffbf00)
                            : Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[800]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _categories[i]["icon"],
                            color: _selectedCategory == _categories[i]
                                ? Colors.black
                                : Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _categories[i]["name"],
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedCategory == _categories[i]
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
