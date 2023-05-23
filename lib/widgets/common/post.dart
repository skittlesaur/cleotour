// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool liked = false;
  int likes = 40;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalMargins = screenWidth * 0.04;
    double padding = screenWidth * 0.03;

    return Scaffold(
        body: Center(
            child: Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color.fromRGBO(32, 32, 33, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargins),
      padding: EdgeInsets.only(top: padding, left: padding, right: padding),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/image.png'),
                foregroundImage: NetworkImage(
                    'https://media.licdn.com/dms/image/D4D03AQGmPBfs91jEYg/profile-displayphoto-shrink_400_400/0/1676393947951?e=1690416000&v=beta&t=Mp1Do9pLScVGwrrToAtyQT5wnGYMxxhQK2i-b52diXw'),
                radius: 25,
                backgroundColor: Color.fromRGBO(32, 32, 33, 1),
              ),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Omar Barbary',
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
                      'Zamalek, Cairo',
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
            '2 hours ago',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey[500], fontFamily: 'Inter', fontSize: 12),
          )
        ]),
        SizedBox(
          height: screenWidth * 0.02,
        ),
        const Text(
          'Exploring Zamalek, Cairo - a vibrant neighborhood with colorful buildings, art galleries, trendy cafes and stunning views of the Nile River. 🇪🇬🌉',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 15,
              height: 1.3),
        ),
        SizedBox(
          height: screenWidth * 0.02,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            'https://hips.hearstapps.com/hmg-prod/images/robert-downey-jr-1673534075.jpg?crop=0.627xw:0.390xh;0.258xw,0.0219xh&resize=1200:*',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                setState(() {
                  liked = !liked;
                  liked ? likes++ : likes--;
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
                  Text(likes.toString(),
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
                onPressed: () {},
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
    )));
  }
}
