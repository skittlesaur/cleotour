import 'package:cleotour/widgets/Userimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSide extends StatelessWidget {
  final User? currentUser;

  UserSide({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UserImagePicker(currentUser: currentUser!),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentUser?.displayName ?? "",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
            Text(
              currentUser?.email ?? "",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }
}
