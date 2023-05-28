// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:cleotour/widgets/add-post/image-input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _postBodyController = TextEditingController();
  final url = Uri.parse(
      'https://cleotour-8bd53-default-rtdb.firebaseio.com/posts.json');
  String postBody = '';

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
                    ImageInput(),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          http.post(url,
                              body: json.encode({
                                'body': _postBodyController.text,
                                'likes': 0
                              }));
                          _postBodyController.text = '';
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

// Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextFormField(
//               controller: _textController,
//               decoration: InputDecoration(
//                   hintText: 'What\'s new?', border: OutlineInputBorder())),
//           MaterialButton(
//             onPressed: () {
//               setState(() {
//                 http.post(url,
//                     body: json
//                         .encode({'body': _textController.text, 'likes': 0}));
//                 _textController.text = '';
//               });
//             },
//             color: Color.fromRGBO(255, 220, 115, 1),
//             child: Text(
//               'Post',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       )
