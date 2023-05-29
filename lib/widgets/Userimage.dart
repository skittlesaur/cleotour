import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImageFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
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
                  : AssetImage('assets/avatardefault.png')
                      as ImageProvider<Object>?,
            ),
            Positioned(
                bottom: -5,
                right: -10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.amber,
                    ),
                  ),
                )),
          ],
        ));
  }
}
