// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool liked = false;
  int likes = 1000000000;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalMargins = screenWidth * 0.04;
    double padding = screenWidth * 0.03;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color.fromRGBO(32, 32, 33, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(
          left: horizontalMargins, right: horizontalMargins, top: 5, bottom: 5),
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
                    'El-Youm 7',
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
                      'Yasmeen 1, New Cairo',
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
          'Finally the most handsome man was spotted in EGYPPPTTT!!!! 🇪🇬🌉',
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
            'https://media.licdn.com/dms/image/D4D03AQGmMdzSofuBQA/profile-displayphoto-shrink_800_800/0/1665876534705?e=1690416000&v=beta&t=sTyRFK17UiNNzfEftuBSkrBU_utoNv5jghaQfCDx3_M',
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
    );
  }
}
