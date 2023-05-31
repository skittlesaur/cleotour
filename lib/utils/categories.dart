import 'package:flutter/material.dart';

class Categories {
  static final List<Map<String, dynamic>> _categories = [
    {
      "name": "All",
      "icon": Icons.all_inbox,
    },
    {
      "name": "Museum",
      "icon": Icons.museum,
    },
    {
      "name": "Restaurant",
      "icon": Icons.restaurant,
    },
    {
      "name": "Hotel",
      "icon": Icons.hotel,
    },
    {
      "name": "Park",
      "icon": Icons.park,
    },
    {
      "name": "Beach",
      "icon": Icons.beach_access,
    },
    {
      "name": "Other",
      "icon": Icons.more_horiz,
    },
  ];

  static List<Map<String, dynamic>> get getCategories {
    return _categories;
  }
}
