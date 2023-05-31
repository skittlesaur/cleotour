import 'package:cleotour/services/posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/post.dart';

class UserPosts extends StatelessWidget {
  final PostsServices postsServices = PostsServices();
  final Function openPost;
  User? currentUser;

  UserPosts({required this.openPost, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: postsServices.fetchUserPostsStream(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.length == 0)
            return Text(
              "You have not posted anything yet",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400]),
            );

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  openPost(Post(
                      id: snapshot.data!.docs[index].id,
                      imageUrl: snapshot.data!.docs[index].get('imageUrl'),
                      body: snapshot.data!.docs[index].get('body'),
                      userId: snapshot.data!.docs[index].get('posterId'),
                      category: snapshot.data!.docs[index].get('category'),
                      rating: int.parse(
                          snapshot.data!.docs[index].get('averageRating'))));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          snapshot.data!.docs[index].get('imageUrl'),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
