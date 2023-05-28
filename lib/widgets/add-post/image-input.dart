import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageInput extends StatefulWidget {
  Function(String) setImage;

  ImageInput({required this.setImage});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;

  Future getImages() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        widget.setImage(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            height: 200,
            child: _image == null
                ? const Icon(Icons.image, size: 100)
                : Image.file(File(_image!.path))),
        const SizedBox(
          width: 10,
        ),
        MaterialButton(
          onPressed: () async {
            await getImages();
          },
          color: Color.fromRGBO(12, 12, 12, 1),
          child: const Text(
            'Pick an image',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
