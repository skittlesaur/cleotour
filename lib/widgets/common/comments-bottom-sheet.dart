import 'package:cleotour/widgets/common/addCommentWidget.dart';
import 'package:cleotour/widgets/common/comment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  CommentsPage({required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Stream<QuerySnapshot> _commentsStream;
  late List<DocumentSnapshot> _commentsList;
  bool _loadingMore = false;
  bool _hasMoreComments = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize the comments stream and list
    _commentsStream = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Comments')
        .orderBy('postedAt', descending: true)
        .snapshots();
    _commentsList = [];

    // Listen for scroll events and load more comments when needed
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreComments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Color.fromRGBO(32, 32, 33, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: StreamBuilder<QuerySnapshot>(
        stream: _commentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading comments'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Add new comments to the list
          _commentsList.addAll(snapshot.data!.docs);

          // Check if there are more comments to load
          if (snapshot.data!.docs.length < 10) {
            _hasMoreComments = false;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text("Comments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _commentsList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot comment = _commentsList[index];
                    return Column(children: [
                      Comment(
                        postId: comment['postId'],
                        author: comment['commenterId'],
                        comment: comment['comment'],
                        postedAt: comment['postedAt'],
                        likes: comment['likes'],
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                              decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                                width: 0.6,
                              ),
                            ),
                          ))),
                    ]);
                  },
                ),
              ),
              if (_loadingMore)
                CircularProgressIndicator()
              else if (_hasMoreComments)
                ElevatedButton(
                  onPressed: _loadMoreComments,
                  child: Text('Load More'),
                ),
              AddCommentWidget(
                postId: widget.postId,
              )
            ],
          );
        },
      ),
    );
  }

  void _loadMoreComments() async {
    if (_hasMoreComments && !_loadingMore) {
      setState(() {
        _loadingMore = true;
      });

      // Load the next batch of comments
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .orderBy('postedAt', descending: true)
          .startAfterDocument(_commentsList.last)
          .limit(10)
          .get();

      // Add the new comments to the list
      _commentsList.addAll(snapshot.docs);

      // Check if there are more comments to load
      if (snapshot.docs.length < 10) {
        _hasMoreComments = false;
      }

      setState(() {
        _loadingMore = false;
      });
    }
  }
}
