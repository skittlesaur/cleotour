import 'package:cleotour/services/posts.dart';
import 'package:cleotour/services/users.dart';
import 'package:cleotour/widgets/common/post.dart';
import 'package:cleotour/widgets/favorites/favorites-header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final PostsServices _postsServices = PostsServices();
  final UsersService _usersService = UsersService();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _usersService.getCurrentUser();
    _isLoggedIn = currentUser != null;
    _getFavourites();
  }

  List<DocumentSnapshot> favs = [];
  bool _isLoading = true;
  bool _isLoggedIn = false;

  void _getFavourites() async {
    DocumentSnapshot user = await _usersService.fetchUser(currentUser!.uid);

    var userFavorites = user['favourites'];

    if (userFavorites == null || userFavorites.length == 0) {
      setState(() {
        _isLoading = false;
        favs = [];
      });
      return;
    }

    QuerySnapshot posts =
        await _postsServices.fetchUserFavorites(userFavorites);

    setState(() {
      _isLoading = false;
      favs = posts.docs;
    });
  }

  Widget getFavoritesContent() {
    // if loading or the user is not logged in, show a loading spinner
    if (_isLoading && _isLoggedIn) {
      return const Center(
        child: SpinKitThreeBounce(
          size: 30,
          color: Colors.white,
        ),
      );
    }

    // if there are no favorites and the user is logged in, show a message
    if (favs.isEmpty && _isLoggedIn) {
      return const Center(
        child: Text(
          'You have no favorites yet!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      );
    }

    // show the favorites
    return Column(
      children: favs.map((f) {
        return Post(
          postId: f['postId'],
          posterId: f['posterId'],
          posterUserName: f['posterUserName'],
          body: f['body'],
          location: f['location'],
          // likes: f['likes'],
          postedAt: f['postedAt'],
          imageUrl: f['imageUrl'],
          category: f['category'],
          isFav: true,
          changeFav: false,
          averageRating: f['averageRating'],
          setParent: () {
            _getFavourites();
          },
        );
      }).toList(),
    );
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
                child: FavoritesHeader(),
              ),
              getFavoritesContent(),
            ],
          ),
        ),
      ),
    );
  }
}
