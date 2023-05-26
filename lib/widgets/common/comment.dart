// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  String author;
  String comment;
  int likes;
  bool liked;

  Comment(
      {required this.author,
      required this.comment,
      required this.likes,
      required this.liked});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.03;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      //margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.only(top: padding, left: padding, right: padding),
      child: Card(
        color: Color.fromRGBO(15, 15, 16, 1),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/image.png'),
                  /*foregroundImage: NetworkImage(
                  'https://shorty-shortener.vercel.app/12oNKo',
                ),*/
                  radius: 18,
                  backgroundColor: Color.fromRGBO(32, 32, 33, 1),
                ),
                SizedBox(height: 100)
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.author,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.comment,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(children: [
                        Text(
                          "20 minutes ago",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Icon(
                              Icons.circle,
                              size: 4,
                              color: Colors.grey[600],
                            ))
                      ]),
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.liked = !widget.liked;
                              widget.liked ? widget.likes++ : widget.likes--;
                            });
                          },
                          child: Row(
                            children: [
                              widget.liked
                                  ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromRGBO(166, 124, 0, 1),
                                            Color.fromRGBO(255, 191, 0, 1),
                                            Color.fromRGBO(255, 220, 115, 1),
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  : Icon(
                                      Icons.favorite_border_outlined,
                                      size: 16,
                                      color: Color.fromRGBO(195, 197, 200, 1),
                                    ),
                              const SizedBox(width: 3),
                              Text(
                                widget.likes.toString(),
                                style: TextStyle(
                                  color: Color.fromRGBO(195, 197, 200, 1),
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      /////////
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
