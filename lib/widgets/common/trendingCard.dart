import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TrendingCard extends StatefulWidget {
  String postId;
  String posterId;
  String posterUserName;
  String body;
  String location;
  String postedAt;
  String imageUrl;
  String category;
  String avgRating;

  TrendingCard(
      {required this.postId,
      required this.posterId,
      required this.posterUserName,
      required this.body,
      required this.location,
      required this.postedAt,
      required this.imageUrl,
      required this.category,
      required this.avgRating});

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  final _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _downloadPfpUrl = getUserImage(widget.posterId);
  }

  late Future<String?> _downloadPfpUrl;

  Future<String> getUserImage(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var userData = userDoc.data();
    var imageURL = userData?['imageUrl'];
    if (imageURL != null) {
      return imageURL as String;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 300,
      width: 500,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Text(
              widget.category,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        child: FutureBuilder(
                            future: _downloadPfpUrl,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                                return Icon(Icons.error, size: 40);
                              } else {
                                return CircleAvatar(
                                    backgroundImage: (snapshot.data! == '')
                                        ? AssetImage('assets/avatardefault.png')
                                            as ImageProvider<Object>?
                                        : CachedNetworkImageProvider(
                                            snapshot.data!),
                                    radius: 25,
                                    backgroundColor:
                                        Color.fromRGBO(32, 32, 33, 1));
                              }
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              widget.location,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            widget.posterUserName,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {},
                          icon: Icon(Icons.star,
                              color: Color.fromRGBO(255, 191, 0, 1))),
                      Text(widget.avgRating,
                          style: TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
