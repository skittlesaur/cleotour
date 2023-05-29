import 'package:flutter/material.dart';

class TrendingCard extends StatefulWidget {
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
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
                              NetworkImage('https://i.imgur.com/OZdGrR9.jpg'),
                        ),
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
                              "Temple of Hathor, Dendera",
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
                          onPressed: () => print("hello"),
                          icon: Icon(Icons.favorite,
                              color: Color.fromRGBO(242, 56, 86, 1))),
                      Text("200", style: TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      padding: EdgeInsets.all(10),
    ));
  }
}
