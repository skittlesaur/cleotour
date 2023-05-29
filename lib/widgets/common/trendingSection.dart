import 'package:flutter/cupertino.dart';
import 'trendingCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrendingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            "Trending Tours",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        Container(
          height: 280,
          child: ListView(
            children: [
              CarouselSlider(
                items: [
                  TrendingCard(),
                  TrendingCard(),
                  TrendingCard(),
                  TrendingCard(),
                  TrendingCard(),
                ],
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
              ),
            ],
          ),
        )
      ],
    );
  }
}
