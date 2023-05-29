// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cleotour/widgets/common/comments-bottom-sheet.dart';
import 'package:cleotour/widgets/common/ratings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends StatefulWidget {
  String postId;
  String posterId;
  String posterUserName;
  String body;
  String location;
  int likes;
  String postedAt;
  String imageUrl;
  String category;

  Post({
    required this.postId,
    required this.posterId,
    required this.posterUserName,
    required this.body,
    required this.location,
    required this.likes,
    required this.postedAt,
    required this.imageUrl,
    required this.category,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int rating = 0;
  // void initRating() async {
  //   // we use the try catch to get an error in case an error happens with firestore
  //   try {
  //     final ratingSnapshot = await FirebaseFirestore.instance
  //         .collection('Posts')
  //         .doc(widget.postId)
  //         .collection('Rating')
  //         .get()
  //         .then((QuerySnapshot QS) {
  //       QS.docs.forEach((doc) {
  //         print(doc);
  //       });
  //     });

  //     // print(documentSnapshot);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // @override
  // void initState() async {
  //   super.initState();
  //   initRating();
  // }

  void _updateRating(int rating) async {
    var newDocRef = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Ratings')
        .doc(Auth().getCurrentUser()?.uid);

    await newDocRef.set({
      'raterId': Auth().getCurrentUser()?.uid,
      'postId': widget.postId,
      'rating': rating
    });
  }

  bool liked = false;
  final _storage = FirebaseStorage.instance;
  String? downloadURL;

  String formatTimestamp(String timestamp) {
    var difference = DateTime.now().difference(DateTime.parse(timestamp));

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  Future<String> downloadFile() async {
    String downloadURL = await _storage.ref(widget.imageUrl).getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.03;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color.fromRGBO(32, 32, 33, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.only(top: padding, left: padding, right: padding),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/image.png'),
                foregroundImage:
                    NetworkImage('https://shorty-shortener.vercel.app/12oNKo'),
                radius: 25,
                backgroundColor: Color.fromRGBO(32, 32, 33, 1),
              ),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.posterUserName,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('#' + widget.category,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w300)),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(
                      Icons.location_on,
                      size: 11,
                      color: Colors.grey[500],
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Text(
                      widget.location,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    )
                  ])
                ],
              ),
            ],
          ),
          Text(
            formatTimestamp(widget.postedAt),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey[500], fontFamily: 'Inter', fontSize: 12),
          )
        ]),
        SizedBox(
          height: screenWidth * 0.02,
        ),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.body,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 15,
                  height: 1.3),
            )),
        SizedBox(
          height: screenWidth * 0.02,
        ),
        GestureDetector(
            onDoubleTap: () {
              setState(() {
                liked = !liked;
                liked ? widget.likes++ : widget.likes--;
              });
            },
            child: FutureBuilder(
                future: downloadFile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error, size: 100);
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        snapshot.data!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                })),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                RatingWidget(
                  onRatingSelected: (rating) {
                    setState(() {
                      this.rating = rating;
                      print(rating);
                      _updateRating(rating);
                    });
                  },
                ),
                SizedBox(
                  height: 0,
                  width: 5,
                ),
                Text(rating.toString(),
                    style: TextStyle(
                        color: Color.fromRGBO(195, 197, 200, 1),
                        fontFamily: 'Inter',
                        fontSize: 20))
              ],
            ),
            SizedBox(
              width: 15,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                    builder: (_) => CommentsPage(postId: widget.postId),
                  );
                },
                child: SizedBox(
                  height: null,
                  width: null,
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 20, color: Color.fromRGBO(195, 197, 200, 1)),
                      SizedBox(
                        height: 0,
                        width: 5,
                      ),
                      Text(40.toString(),
                          style: TextStyle(
                              color: Color.fromRGBO(195, 197, 200, 1),
                              fontFamily: 'Inter',
                              fontSize: 20))
                    ],
                  ),
                )),
          ],
        ),
      ]),
    );
  }
}
