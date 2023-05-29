import 'package:flutter/material.dart';

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

  TrendingCard({
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
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 300,
      width: 500,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network('https://i.imgur.com/4Kf1fKK.png',
                height: 250, width: double.infinity, fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.all(10),
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
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
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
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => print("hello"),
                          icon: Icon(Icons.star,
                              color: Color.fromRGBO(255, 191, 0, 1))),
                      Text("200", style: TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      padding: EdgeInsets.all(30),
    ));
  }
}
