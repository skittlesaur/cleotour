import 'package:flutter/material.dart';

import '../widgets/common/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common/trendingSection.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _categories = [
    {
      "name": "All",
      "icon": Icons.all_inbox,
    },
    {
      "name": "Museum",
      "icon": Icons.museum,
    },
    {
      "name": "Restaurant",
      "icon": Icons.restaurant,
    },
    {
      "name": "Hotel",
      "icon": Icons.hotel,
    },
    {
      "name": "Park",
      "icon": Icons.park,
    },
    {
      "name": "Beach",
      "icon": Icons.beach_access,
    },
    {
      "name": "Other",
      "icon": Icons.more_horiz,
    },
  ];

  String categoryValue = "All";
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _posts = [];
  bool _isLoading = false;
  bool _loadedAllPosts = false;

  final int FETCH_POSTS_LIMIT = 2;

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

    // _posts.clear();

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('postedAt', descending: true);

    if (categoryValue != "All") {
      query = query.where('category', isEqualTo: categoryValue);
    }

    if (_posts.length > 0) {
      query = query.startAfterDocument(_posts[_posts.length - 1]);
    }

    QuerySnapshot querySnapshot = await query.limit(FETCH_POSTS_LIMIT).get();

    // @todo: remove this print statement
    print("Loaded ${querySnapshot.docs.length} new posts");
    setState(() {
      _posts.addAll(querySnapshot.docs);
      _isLoading = false;
      if (querySnapshot.docs.length < FETCH_POSTS_LIMIT) {
        _loadedAllPosts = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: /*_posts.isEmpty
            ? Center(child: CircularProgressIndicator())
            : */
            // RefreshIndicator(
            // onRefresh: () {
            //   return _fetchPosts();
            // },
            // child:
            SingleChildScrollView(
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
              Container(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryValue = _categories[index]['name'];
                          _posts = [];
                        });
                        _fetchPosts();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: categoryValue == _categories[index]['name']
                              ? Color(0xffffbf00)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _categories[index]['icon'],
                              color: categoryValue == _categories[index]['name']
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              _categories[index]['name'],
                              style: TextStyle(
                                color:
                                    categoryValue == _categories[index]['name']
                                        ? Colors.black
                                        : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  ..._posts.map((post) {
                    return Post(
                      postId: post.id,
                      body: post['body'],
                      location: post['location'],
                      category: post['category'],
                      posterId: post['posterId'],
                      posterUserName: post['posterUserName'],
                      likes: post['likes'],
                      imageUrl: post['imageUrl'],
                      postedAt: post['postedAt'],
                      averageRating: post['averageRating'],
                      isFav: false,
                      setParent: () {},
                    );
                  }).toList(),
                  _isLoading
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
                  !_isLoading && _posts.length == 0
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
              ),
            ],
          ),
        )
        // )
        );
  }
}
