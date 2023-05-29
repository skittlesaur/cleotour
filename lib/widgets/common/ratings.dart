import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final void Function(int rating) onRatingSelected;
  int prevRating;
  bool isLoggedIn;

  RatingWidget(
      {required this.onRatingSelected,
      required this.isLoggedIn,
      required this.prevRating});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    _rating = widget.prevRating;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory),
            child: _rating >= 1
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
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.grey[700],
                    size: 20,
                  ),
            onPressed: () {
              if (widget.isLoggedIn) {
                setState(() {
                  _rating = 1;
                });
              }
              widget.onRatingSelected(_rating);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory),
            child: _rating >= 2
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
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.grey[700],
                    size: 20,
                  ),
            onPressed: () {
              if (widget.isLoggedIn) {
                setState(() {
                  _rating = 2;
                });
              }
              widget.onRatingSelected(_rating);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory),
            child: _rating >= 3
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
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.grey[700],
                    size: 20,
                  ),
            onPressed: () {
              if (widget.isLoggedIn) {
                setState(() {
                  _rating = 3;
                });
              }
              widget.onRatingSelected(_rating);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory),
            child: _rating >= 4
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
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.grey[700],
                    size: 20,
                  ),
            onPressed: () {
              if (widget.isLoggedIn) {
                setState(() {
                  _rating = 4;
                });
              }
              widget.onRatingSelected(_rating);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory),
            child: _rating >= 5
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
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.grey[700],
                    size: 20,
                  ),
            onPressed: () {
              if (widget.isLoggedIn) {
                setState(() {
                  _rating = 5;
                });
              }
              widget.onRatingSelected(_rating);
            },
          ),
        ],
      ),
    );
  }
}
