import 'package:cleotour/utils/categories.dart';
import 'package:flutter/material.dart';

class CategoryPicker extends StatelessWidget {
  final List<Map<String, dynamic>> _categories = Categories.getCategories;

  final String categoryValue;
  final Function(String) onCategoryChanged;

  CategoryPicker(
      {required this.categoryValue, required this.onCategoryChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onCategoryChanged(_categories[index]['name']);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: categoryValue == _categories[index]['name']
                    ? Color(0xffffbf00)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Icon(
                    _categories[index]['icon'],
                    color: categoryValue == _categories[index]['name']
                        ? Colors.black
                        : Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _categories[index]['name'],
                    style: TextStyle(
                      color: categoryValue == _categories[index]['name']
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
