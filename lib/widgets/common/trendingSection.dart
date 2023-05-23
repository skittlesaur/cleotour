import 'package:flutter/cupertino.dart';
import 'trendingCard.dart';
import 'package:flutter/material.dart';

class TrendingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 20),
          child: Text(
            "Trending Tours",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        Container(
          height: 300,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TrendingCard(),
                  TrendingCard(),
                  TrendingCard(),
                ],
              )),
        )
      ],
    );
  }
}
