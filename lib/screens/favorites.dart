import 'package:cleotour/widgets/common/post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    _getFavourites();
  }

  List<DocumentSnapshot> favs = [];

  void _getFavourites() async {
    var userDocRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().getCurrentUser()?.uid);

    var docSnapshot = await userDocRef.get();
    if (docSnapshot.exists) {
      var userData = docSnapshot.data();
      var favoritesData = userData!['favourites'];

      // Retrieve and display favorite posts
      List<DocumentSnapshot> favoritePosts = [];
      for (var postId in favoritesData) {
        var postDocSnapshot = await FirebaseFirestore.instance
            .collection('Posts')
            .doc(postId)
            .get();

        if (postDocSnapshot.exists) {
          favoritePosts.add(postDocSnapshot);
        }
      }
      setState(() {
        favs = favoritePosts;
      });
    } else {
      print("User doesn't have favorites.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: favs.map((f) {
          // var favData = f.data();
          return Post(
              postId: f['postId'],
              posterId: f['posterId'],
              posterUserName: f['posterUserName'],
              body: f['body'],
              location: f['location'],
              likes: f['likes'],
              postedAt: f['postedAt'],
              imageUrl: f['imageUrl'],
              category: f['category']);
        }).toList(),
      ),
    ));
  }
}
