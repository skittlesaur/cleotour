import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserImagePicker extends StatefulWidget {
  User currentUser;
  UserImagePicker({required this.currentUser});

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final _storage = FirebaseStorage.instance;
  final _userCollection = FirebaseFirestore.instance.collection('users');
  File? _pickedImage;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.currentUser.photoURL ??
        ''; // Initialize with currentUser.photoURL or an empty string
  }

  Future<void> _pickImage(bool gallery) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImageFile;
    (gallery)
        ? pickedImageFile = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 50,
            maxWidth: 150,
          )
        : pickedImageFile = await _picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 50,
            maxWidth: 150,
          );

    if (pickedImageFile != null) {
      setState(() {
        (pickedImageFile != null)
            ? _pickedImage = File(pickedImageFile.path)
            : _pickedImage = null;
      });
      final ref =
          _storage.ref().child('profilePictures/${widget.currentUser.uid}');
      var image = File(pickedImageFile.path);
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      await widget.currentUser.updatePhotoURL(imageUrl);
      await _userCollection
          .doc(widget.currentUser.uid)
          .update({"imageUrl": imageUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.amber,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!)
                  : _imageUrl != null
                      ? NetworkImage(_imageUrl)
                      : AssetImage('assets/avatardefault.png')
                          as ImageProvider<Object>?,
            ),
            Positioned(
                bottom: -10,
                right: -10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: PopupMenuButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (context) => [
                      // toggle between dark and light mode
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () => _pickImage(false),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "camera",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () => _pickImage(true),
                          child: Row(
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                    ),
                  ),
                )),
          ],
        ));
  }
}
