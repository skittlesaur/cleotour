import 'package:cleotour/widgets/common/post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../auth.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    if (Auth().getCurrentUser()?.uid != null) {
      _isLoggedIn = true;
    }
    _getFavourites();
  }

  List<DocumentSnapshot> favs = [];
  bool _isLoading = true;
  bool _isLoggedIn = false;

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
        _isLoading = false;
      });
    } else {
      print("User doesn't have favorites.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: _isLoggedIn
                      ? const Text(
                          'Favourites',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        )
                      : const Center(
                          child: Text(
                            'You are not logged in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        )),
              _isLoading && _isLoggedIn
                  ? const Center(
                      child: SpinKitThreeBounce(
                      size: 30,
                      color: Colors.white,
                    ))
                  : (favs.isEmpty && _isLoggedIn)
                      ? const Center(
                          child: Text(
                            'You have no favorites yet!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        )
                      : Column(
                          children: favs.map((f) {
                            return Post(
                              postId: f['postId'],
                              posterId: f['posterId'],
                              posterUserName: f['posterUserName'],
                              body: f['body'],
                              location: f['location'],
                              likes: f['likes'],
                              postedAt: f['postedAt'],
                              imageUrl: f['imageUrl'],
                              category: f['category'],
                              isFav: true,
                              setParent: () {
                                setState(() {
                                  _getFavourites();
                                });
                              },
                            );
                          }).toList(),
                        ),
            ],
          )),
        ));
  }
}
