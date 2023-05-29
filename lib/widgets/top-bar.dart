import 'package:cleotour/auth.dart';
import 'package:cleotour/widgets/user-chip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  Function changeAddingPost;
  bool isAddingPost;
  Function changeIndex;
  User? currentUser = Auth().getCurrentUser();

  TopBar(
      {required this.changeAddingPost,
      required this.isAddingPost,
      required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "cleotour",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          currentUser != null
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        changeAddingPost(!isAddingPost);
                      },
                      icon: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: Border.all(color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          isAddingPost ? Icons.close : Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    UserChip(
                      changeAddingPost: changeAddingPost,
                      isAddingPost: isAddingPost,
                      changeIndex: changeIndex,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
