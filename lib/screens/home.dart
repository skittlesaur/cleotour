import 'package:flutter/material.dart';

import '../widgets/common/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common/trendingSection.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String categoryValue = "All";
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _posts = [];
  bool _isLoading = false;

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

  void _fetchPosts() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot querySnapshot;
      if (_posts.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('Posts')
            .orderBy('postedAt', descending: true)
            .limit(FETCH_POSTS_LIMIT)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('Posts')
            .orderBy('postedAt', descending: true)
            .startAfterDocument(_posts.last)
            .limit(FETCH_POSTS_LIMIT)
            .get();
      }

      // @todo: remove this print statement
      print("Loaded ${querySnapshot.docs.length} new posts");
      setState(() {
        _posts.addAll(querySnapshot.docs);
        _isLoading = false;
      });
    }
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
                padding: EdgeInsets.all(10),
                child: Text(
                  "Trending Tours",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
              TrendingSection(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Color.fromRGBO(255, 191, 0, 1),
                    focusColor: Colors.grey.shade900,
                    value: categoryValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        categoryValue = newValue!;
                      });
                    },
                    icon: Icon(Icons.format_list_bulleted_sharp),
                    iconSize: 24.0,
                    elevation: 16,
                    underline: SizedBox(),
                    items: ['Beach', 'Club', 'Museum', 'Restaurant', 'All']
                        .map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.white),
                        ),
                        value: item,
                      );
                    }).toList(),
                  )
                ],
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: getPosts(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       return Text("Something went wrong");
              //     }
              //
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       physics: NeverScrollableScrollPhysics(),
              //       itemCount: snapshot.data!.docs.length,
              //       itemBuilder: (context, index) {
              //         return Post(
              //           postId: snapshot.data!.docs[index].id,
              //           body: snapshot.data!.docs[index]['body'],
              //           location: snapshot.data!.docs[index]['location'],
              //           category: snapshot.data!.docs[index]['category'],
              //           posterId: snapshot.data!.docs[index]['posterId'],
              //           posterUserName: snapshot.data!.docs[index]
              //               ['posterUserName'],
              //           likes: snapshot.data!.docs[index]['likes'],
              //           imageUrl: snapshot.data!.docs[index]['imageUrl'],
              //           postedAt: snapshot.data!.docs[index]['postedAt'],
              //         );
              //       },
              //     );
              //   },
              // ),
              Column(
                children: _posts.map((post) {
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
                  );
                }).toList(),
              ),
            ],
          ),
        ));
  }
}
