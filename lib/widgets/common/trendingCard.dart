import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TrendingCard extends StatefulWidget {
  String postId;
  String posterId;
  String posterUserName;
  String body;
  String location;
  int likes;
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
      required this.likes,
      required this.postedAt,
      required this.imageUrl,
      required this.category,
      required this.avgRating});

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  final _storage = FirebaseStorage.instance;
  var img;

  Future<String> downloadFile(String imageUrl) async {
    String downloadURL = await _storage.ref(imageUrl).getDownloadURL();
    img = downloadURL;
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 300,
      width: 500,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          FutureBuilder(
            future: downloadFile(widget.imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Icon(Icons.error, size: 100);
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    snapshot.data!,
                    height: 250,
                    width: double.infinity,
                  ),
                );
              }
            },
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade900,
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                // NetworkImage('https://i.imgur.com/VRWDRXL.png'),
                                AssetImage('assets/image.png')),
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
                            "Slim Abdennadher",
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
