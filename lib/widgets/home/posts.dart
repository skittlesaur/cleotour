import 'package:cleotour/widgets/common/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostsList extends StatelessWidget {
  final List<DocumentSnapshot> posts;
  final bool isLoading;

  PostsList({required this.posts, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...posts.map((post) {
          return Post(
            postId: post.id,
            body: post['body'],
            location: post['location'],
            category: post['category'],
            posterId: post['posterId'],
            posterUserName: post['posterUserName'],
            // likes: post['likes'],
            imageUrl: post['imageUrl'],
            postedAt: post['postedAt'],
            averageRating: post['averageRating'],
            isFav: false,
            setParent: () {},
          );
        }).toList(),
        isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.black,
                child: Text(
                  "Loading...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
        !isLoading && posts.length == 0
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.black,
                child: Text(
                  "No posts found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
