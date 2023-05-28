// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cleotour/widgets/common/addCommentWidget.dart';
import 'package:flutter/material.dart';
import 'package:cleotour/widgets/common/comment.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Post extends StatefulWidget {
  String body;
  String location;
  int likes;
  String postedAt;
  String imageUrl;

  Post(
      {required this.body,
      required this.location,
      required this.likes,
      required this.postedAt,
      required this.imageUrl});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
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
      margin: EdgeInsets.symmetric(vertical: 5),
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
                  Text(
                    'Placeholder',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
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
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashFactory: NoSplash.splashFactory),
              onPressed: () {
                setState(() {
                  liked = !liked;
                  liked ? widget.likes++ : widget.likes--;
                });
              },
              child: Row(
                children: [
                  (liked
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(166, 124, 0, 1),
                                Color.fromRGBO(255, 191, 0, 1),
                                Color.fromRGBO(255, 220, 115, 1)
                              ],
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : Icon(
                          Icons.favorite_border_outlined,
                          size: 20,
                          color: Color.fromRGBO(195, 197, 200, 1),
                        )),
                  SizedBox(
                    height: 0,
                    width: 5,
                  ),
                  Text(widget.likes.toString(),
                      style: TextStyle(
                          color: Color.fromRGBO(195, 197, 200, 1),
                          fontFamily: 'Inter',
                          fontSize: 20))
                ],
              ),
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
                    splashFactory: NoSplash.splashFactory
                    // enableFeedback: false,
                    ),
                onPressed: () {
                  _showCommentSheet(context);
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

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(15, 15, 16, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
            child: Column(children: [
              SizedBox(height: 16),
              Text("Comments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Expanded(
                  child: ListView.builder(
                itemCount: comments
                    .length, // Replace with the actual number of comments
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = comments[index];
                  return ListTile(title: comment);
                },
              )),
              AddCommentWidget()
            ]));
      },
    );
  }

  Widget _buildComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Comment(
            author: "Youssef Saad",
            comment:
                "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
            likes: 0,
            liked: false),
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
              ),
            )),
        Comment(
            author: "Youssef Saad",
            comment:
                "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
            likes: 0,
            liked: false),
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
              ),
            )),
        Comment(
            author: "Youssef Saad",
            comment:
                "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
            likes: 0,
            liked: false),
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
              ),
            ))
      ],
    );
  }
}
