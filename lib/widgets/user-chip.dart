import 'package:cleotour/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserChip extends StatelessWidget {
  Function changeAddingPost;
  bool isAddingPost;
  Function changeIndex;
  User? currentUser = Auth().getCurrentUser();

  UserChip(
      {required this.changeAddingPost,
      required this.isAddingPost,
      required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Container();
    }

    return PopupMenuButton(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade800)),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: TextButton(
          onPressed: () {
            // hide the popup menu first
            Navigator.of(context).pop();
            // hide the add post page just in case
            changeAddingPost(false);
            // then change the index
            changeIndex(2);
          },
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Profile",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ],
          ),
        )),
        PopupMenuItem(
            child: TextButton(
          onPressed: () {
            // hide the popup menu first
            Navigator.of(context).pop();
            // show the add post page
            changeAddingPost(!isAddingPost);
          },
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Add Post",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ],
          ),
        )),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Auth().signOut();
            },
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Logout",
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
      child: Chip(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        backgroundColor: Color(0xfffff8ee),
        shadowColor: Colors.white,
        avatar: CircleAvatar(
          backgroundImage: NetworkImage(currentUser!
              .photoURL!), //bug: if user is signed and doesnt have a pfp everything breaks
        ),
        label: Text(
          currentUser!.displayName!,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
    );
  }
}
