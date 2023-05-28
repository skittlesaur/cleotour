import 'package:flutter/material.dart';

import '../widgets/common/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot<Object?>> getPosts() {
    return FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("postedAt", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: getPosts(),
              builder: (ctx, strSnapshot) {
                if (strSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var myDocuments = strSnapshot.data!.docs;

                return ListView.builder(
                  itemBuilder: (itemCtx, index) {
                    var document = myDocuments[index].data() as Map;

                    return Post(
                        postId: document['postId'],
                        posterId: document['posterId'],
                        posterUserName: document['posterUserName'],
                        body: document['body'],
                        location: document['location'],
                        likes: document['likes'],
                        postedAt: document['postedAt'],
                        imageUrl: document['imageUrl']);
                  },
                  itemCount: myDocuments.length,
                );
              })),
    );
  }
}
