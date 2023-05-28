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
                ? const Icon(color: Colors.amber, Icons.image, size: 100)
                : Image.file(File(_image!.path))),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
            height: 50,
            width: 122,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: Colors.amber,
                    width: 1,
                  )),
              onPressed: () async {
                await getImages();
              },
              child: const Text(
                'Pick an image',
                style: TextStyle(color: Colors.amber),
              ),
            ))
      ],
    );
  }
}
