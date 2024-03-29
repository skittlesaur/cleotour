// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cleotour/widgets/common/alertDialogWidget.dart';
import 'package:cleotour/widgets/common/comments-bottom-sheet.dart';
import 'package:cleotour/widgets/common/ratings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../notifications/notification_service.dart';

class Post extends StatefulWidget {
  String postId;
  String posterId;
  String posterUserName;
  String body;
  String location;
  String postedAt;
  String imageUrl;
  String category;
  bool isFav;
  Function setParent;
  String averageRating;
  bool changeFav;

  Post({
    required this.postId,
    required this.posterId,
    required this.posterUserName,
    required this.body,
    required this.location,
    required this.postedAt,
    required this.imageUrl,
    required this.category,
    required this.isFav,
    required this.setParent,
    this.averageRating = "0",
    this.changeFav = true,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() {
    super.initState();
    _isFavourited = widget.isFav;
    checkIfFavourite();
    _downloadPfpUrl = getUserImage(widget.posterId);
  }

  int rating = 0;

  bool checkLoggedIn() {
    return (Auth().getCurrentUser()?.uid != null);
  }

  late Future<String?> _downloadPfpUrl;

  storeAverageRatings(int rating) async {
    setState(() {
      widget.averageRating = rating.toString();
    });
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
        average += value.docs[i]
            .data()['rating']; // use value.size instead of ratings.count()
      }
    });

    if (average == 0) {
      if (Auth().getCurrentUser()?.uid != null) {
        storeAverageRatings(0);
      }
      return 0;
    } else {
      if (Auth().getCurrentUser()?.uid != null)
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Auth().getCurrentUser()?.uid)
          .update({
        'favourites': FieldValue.arrayUnion([widget.postId])
      });
      setState(() {
        _isFavourited = true;
        NotificationService().showNotification(title: 'Post Favorited');
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
      var favorites = userData?['favourites'];
      if (favorites != null) {
        if (favorites.contains(widget.postId)) {
          _isFavourited = true;
        }
      }
    }
  }

  Future<String?> getUserImage(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var userData = userDoc.data();
    var imageURL = userData?['imageUrl'];
    if (imageURL != null) {
      return imageURL as String;
    }
    return null;
  }

  void unFavourite() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().getCurrentUser()?.uid)
        .update({
      'favourites': FieldValue.arrayRemove([widget.postId])
    });
    // setState(() {
    //   _isFavourited = false;
    // });
    if (widget.changeFav) {
      setState(() {
        _isFavourited = false;
      });
    }
    widget.setParent();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: _downloadPfpUrl,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Icon(Icons.error, size: 40);
                    } else {
                      return CircleAvatar(
                        backgroundImage: (snapshot.data != null)
                            ? NetworkImage(snapshot.data!)
                            : AssetImage('assets/avatardefault.png')
                                as ImageProvider<Object>?,
                        radius: 25,
                        backgroundColor: Color.fromRGBO(32, 32, 33, 1),
                      );
                    }
                  }),
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
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text('#' + widget.category,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Text(widget.averageRating,
                                  style: TextStyle(
                                      color: Color.fromRGBO(195, 197, 200, 1),
                                      fontFamily: 'Inter',
                                      fontSize: 10)),
                            )
                          ],
                        ),
                      ),
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      formatTimestamp(widget.postedAt),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: 'Inter',
                          fontSize: 12),
                    )
                  ])
                ],
              ),
            ],
          ),
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
              if (!_isFavourited) {
                setState(() {
                  _addFavourite();
                });
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )),
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
                          return RatingWidget(
                            prevRating: rating,
                            isLoggedIn: checkLoggedIn(),
                            onRatingSelected: (rating) {},
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'No Internet connection ',
                            style: TextStyle(color: Colors.white),
                          );
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
                          child: SizedBox(
                            height: null,
                            width: null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 5),
                              child: Icon(Icons.chat_bubble_outline_rounded,
                                  size: 20,
                                  color: Color.fromRGBO(195, 197, 200, 1)),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
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
