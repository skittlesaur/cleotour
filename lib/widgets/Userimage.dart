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
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.amber,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!)
              : const NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/1048/1048549.png?w=740&t=st=1685389297~exp=1685389897~hmac=26103e20d20a8e55be1926cab1c35ff04968e9b0a28d24bbc7484d26aeaf70d9")
                  as ImageProvider<Object>?,
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
