// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cleotour/widgets/common/alertDialogWidget.dart';
import 'package:cleotour/widgets/common/comments-bottom-sheet.dart';
import 'package:cleotour/widgets/common/ratings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  @override
  void initState() {
    super.initState();
    checkIfFavourite();
  }

  int rating = 0;
  bool checkLoggedIn() {
    return (Auth().getCurrentUser()?.uid != null);
  }

  storeAverageRatings(int rating) async {
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .set({'averageRating': rating.toString()}, SetOptions(merge: true));
  }

  getRatingsAverage() async {
    var amountOfRatings = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Ratings')
        .count()
        .get()
        .then((value) {
      return value.count;
    });

    num average = 0;
    var ratings = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Ratings')
        .get()
        .then((value) {
      for (int i = 0; i < amountOfRatings; i++) {
        average += value.docs[i].data()['rating'];
      }
    });

    if (average == 0) {
      storeAverageRatings(0);
      return 0;
    } else {
      storeAverageRatings((average / amountOfRatings).ceil());
      return ((average / amountOfRatings).ceil());
    }
  }

  void _updateRating(int rating) async {
    var userRatingDoc = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Ratings')
        .doc(Auth().getCurrentUser()?.uid);

    await userRatingDoc.set({
      'raterId': Auth().getCurrentUser()?.uid,
      'postId': widget.postId,
      'rating': rating
    });
  }

  void _addFavourite() async {
    if (Auth().getCurrentUser()?.uid != null) {
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(Auth().getCurrentUser()?.uid)
      //     .collection('favourites')
      //     .add({'postId': widget.postId});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Auth().getCurrentUser()?.uid)
          .update({
        'favourites': FieldValue.arrayUnion([widget.postId])
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogWidget(
              title: "Login required",
              content: "You must be logged in to be able to favorite posts");
        },
      );
    }
  }

  bool _isFavourited = false;
  void checkIfFavourite() async {
    if (Auth().getCurrentUser()?.uid != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(Auth().getCurrentUser()?.uid)
          .get();
      var userData = userDoc.data();
      var favorites = userData!['favourites'];
      if (favorites != null) {
        if (favorites.contains(widget.postId)) {
          _isFavourited = true;
        }
      }
    }
  }

  void unFavourite() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().getCurrentUser()?.uid)
        .update({
      'favourites': FieldValue.arrayRemove([widget.postId])
    });
    setState(() {
      _isFavourited = false;
    });
  }

  Future<int> getRating() async {
    var snap = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Ratings')
        .doc(Auth().getCurrentUser()?.uid)
        .get()
        .then((value) => value.data()?['rating']);

    if (snap != null) {
      return (snap);
    } else {
      return 0;
    }
  }

  // void avgRating() async {
  //   var snaps = await FirebaseFirestore.instance
  //       .collection('Posts')
  //       .doc(widget.postId)
  //       .collection('Ratings')
  //       .snapshots();

  //   snaps.map((snapshot) {
  //     if (snapshot.docs.isEmpty) {
  //       print('0'); // Return 0 if no ratings found
  //     }
  //     double totalRating = 0.0;
  //     int count = 0;
  //     for (var doc in snapshot.docs) {
  //       var data = doc.data();
  //       if (data != null && data.containsKey('rating')) {
  //         totalRating += (data['rating'] as double);
  //         count++;
  //       }
  //     }
  //     if (count > 0) {
  //       print(totalRating / count);
  //     } else {
  //       print("0"); // Return 0 if no valid ratings found
  //     }
  //   });
  // }

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
                // foregroundImage:
                //     NetworkImage('https://shorty-shortener.vercel.app/12oNKo'),
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
        InkWell(
            onDoubleTap: () {
              // setState(() {
              //   liked = !liked;
              //   liked ? widget.likes++ : widget.likes--;
              //   print("favourite");
              // });
              _addFavourite();
              setState(() {
                _isFavourited = true;
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
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                })),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    FutureBuilder<int>(
                      future: getRating(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text('Loading...'));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return RatingWidget(
                            prevRating: snapshot.data ?? 0,
                            isLoggedIn: checkLoggedIn(),
                            onRatingSelected: (rating) {
                              if (checkLoggedIn()) {
                                setState(() {
                                  this.rating = rating;
                                  _updateRating(rating);
                                  getRatingsAverage();
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialogWidget(
                                        title: "Login required",
                                        content: "You must be logged in first");
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 0,
                      width: 5,
                    ),
                    FutureBuilder(
                      future: getRatingsAverage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text('Loading...'));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data.toString(),
                              style: TextStyle(
                                  color: Color.fromRGBO(195, 197, 200, 1),
                                  fontFamily: 'Inter',
                                  fontSize: 20));
                        }
                      },
                    ),
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
                              size: 20,
                              color: Color.fromRGBO(195, 197, 200, 1)),
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
            _isFavourited
                ? IconButton(
                    onPressed: () {
                      unFavourite();
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Color(0xffffbf00),
                    ))
                : Container()
          ],
        ),
      ]),
    );
  }
}

// Text(rating.toString(),
//                     style: TextStyle(
//                         color: Color.fromRGBO(195, 197, 200, 1),
//                         fontFamily: 'Inter',
//                         fontSize: 20))