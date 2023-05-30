// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment extends StatefulWidget {
  String postId;
  String authorId;
  String authorUserName;
  String comment;
  String postedAt;
  Comment({
    required this.postId,
    required this.authorId,
    required this.authorUserName,
    required this.comment,
    required this.postedAt,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  Future<String> getUserImage(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var userData = userDoc.data();
    var imageURL = userData?['imageUrl'];
    if (imageURL != null) {
      return imageURL as String;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.03;

    String formatTimestamp(String timestamp) {
      var difference = DateTime.now().difference(DateTime.parse(timestamp));

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'just now';
      }
    }

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      //margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.only(top: padding, left: padding, right: padding),
      child: Card(
        elevation: 0,
        color: Color.fromRGBO(32, 32, 33, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: getUserImage(widget.authorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar(
                        backgroundColor: Color.fromRGBO(32, 32, 33, 1),
                        radius: 18,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return CircleAvatar(
                        backgroundColor: Color.fromRGBO(32, 32, 33, 1),
                        radius: 18,
                        child: Icon(Icons.error),
                      );
                    } else {
                      final imageUrl = snapshot.data;
                      return CircleAvatar(
                        backgroundImage: (imageUrl == '')
                            ? AssetImage('assets/avatardefault.png')
                                as ImageProvider<Object>?
                            : NetworkImage(imageUrl!),
                        radius: 18,
                        backgroundColor: Color.fromRGBO(32, 32, 33, 1),
                      );
                    }
                  },
                ),
                SizedBox(width: 6),
                Text(
                  widget.authorUserName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 45)
              ],
            ),
            //const SizedBox(width: 8),
            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      textAlign: TextAlign.left,
                      widget.comment,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            formatTimestamp(widget.postedAt),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
