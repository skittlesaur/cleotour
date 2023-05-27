import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  final _storageUrl = Uri.parse(
      'https://cleotour-8bd53-default-rtdb.firebaseio.com/posts.json');

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      this._storedImage = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Icon(Icons.image, size: 100),
        ),
        const SizedBox(
          width: 10,
        ),
        MaterialButton(
          onPressed: () {
            getImage();
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
