import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  String title;
  String content;

  AlertDialogWidget({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(32, 32, 33, 1),
      title: Text(title, style: TextStyle(color: Colors.white)),
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('OK', style: TextStyle(color: Colors.amber)),
        ),
      ],
    );
  }
}
