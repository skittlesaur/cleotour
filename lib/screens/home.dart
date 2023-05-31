import 'package:cleotour/services/posts.dart';
import 'package:cleotour/widgets/home/category-picker.dart';
import 'package:cleotour/widgets/home/posts.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common/trendingSection.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostsServices _postsServices = PostsServices();

  String categoryValue = "All";
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _posts = [];
  bool _isLoading = false;
  bool _loadedAllPosts = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPosts();
    }
  }

  Future<void> _fetchPosts() async {
    if (_isLoading || _loadedAllPosts) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot querySnapshot =
        await _postsServices.fetchPostsPaginated(categoryValue, _posts);

    setState(() {
      _posts.addAll(querySnapshot.docs);
      _isLoading = false;
      if (querySnapshot.docs.length < _postsServices.getFetchPostsLimit) {
        _loadedAllPosts = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Trending Tours",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
            TrendingSection(),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Recent",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
            CategoryPicker(
              categoryValue: categoryValue,
              onCategoryChanged: (value) {
                setState(() {
                  categoryValue = value;
                  _posts.clear();
                });
                _fetchPosts();
              },
            ),
            SizedBox(
              height: 10,
            ),
            PostsList(
              posts: _posts,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
