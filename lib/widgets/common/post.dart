// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cleotour/widgets/common/alertDialogWidget.dart';
import 'package:cleotour/widgets/common/comments-bottom-sheet.dart';
import 'package:cleotour/widgets/common/ratings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  bool isFav;
  Function setParent;

  Post(
      {required this.postId,
      required this.posterId,
      required this.posterUserName,
      required this.body,
      required this.location,
      required this.likes,
      required this.postedAt,
      required this.imageUrl,
      required this.category,
      required this.isFav,
      required this.setParent});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() {
    super.initState();
    checkIfFavourite();
    _isFavourited = widget.isFav;
    _downloadUrl = downloadFile();
  }

  int rating = 0;
  bool checkLoggedIn() {
    return (Auth().getCurrentUser()?.uid != null);
  }

  late Future<String> _downloadUrl;

  Future<String> downloadFile() async {
    String downloadURL = await _storage.ref(widget.imageUrl).getDownloadURL();
    return downloadURL;
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
      setState(() {
        _isFavourited = true;
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
    setState(() {
      _isFavourited = false;
    });
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
            children: [
              FutureBuilder(
                  future: getUserImage(widget.posterId),
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
                            : AssetImage('assets/image.png')
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

              setState(() {
                _addFavourite();
              });
            },
            child: FutureBuilder(
                future: _downloadUrl,
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
                      child: SizedBox(
                        height: null,
                        width: null,
                        child: Icon(Icons.chat_bubble_outline_rounded,
                            size: 20, color: Color.fromRGBO(195, 197, 200, 1)),
                      )),
                )
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
