import 'package:flutter/cupertino.dart';
import 'trendingCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrendingSection extends StatefulWidget {
  @override
  State<TrendingSection> createState() => _TrendingSectionState();
}

class _TrendingSectionState extends State<TrendingSection> {
  Stream<QuerySnapshot<Object?>> getPosts() {
    return FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("averageRating", descending: true)
        .limit(3)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 8),
          child: Text(
            "Trending Tours",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Container(
          height: 300,
          child: StreamBuilder<QuerySnapshot>(
              stream: getPosts(),
              builder: (ctx, strSnapshot) {
                if (strSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var myDocuments = strSnapshot.data!.docs;
                List<TrendingCard> trendingCards = myDocuments.map((doc) {
                  var document = doc.data() as Map;
                  return TrendingCard(
                    postId: document['postId'],
                    posterId: document['posterId'],
                    posterUserName: document['posterUserName'],
                    body: document['body'],
                    location: document['location'],
                    likes: document['likes'],
                    postedAt: document['postedAt'],
                    imageUrl: document['imageUrl'],
                    category: document['category'],
                    avgRating: document['averageRating'],
                  );
                }).toList();
                return CarouselSlider(
                  items: trendingCards,
                  options: CarouselOptions(
                    height: 280.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 1,
                  ),
                );
              }),
        )
      ],
    );
  }
}
