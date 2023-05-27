import 'package:flutter/material.dart';
import 'comment.dart';

List<Comment> comments = [
  Comment(
      author: "Youssef Saad",
      comment:
          "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
      likes: 0,
      liked: false),
  Comment(
      author: "Youssef Saad",
      comment:
          "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
      likes: 0,
      liked: false),
  Comment(
      author: "Youssef Saad",
      comment:
          "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
      likes: 0,
      liked: false),
  Comment(
      author: "Youssef Saad",
      comment:
          "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
      likes: 0,
      liked: false),
  Comment(
      author: "Youssef Saad",
      comment:
          "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
      likes: 0,
      liked: false)
];

TextEditingController _textEditingController = TextEditingController();
String inputValue = _textEditingController.text;


class AddCommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      height: 85,
      padding: EdgeInsets.all(8.0),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 19.0,
              backgroundImage: AssetImage('assets/image.png'),
              backgroundColor: Color.fromRGBO(32, 32, 33, 1)),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              onSubmitted: (inputValue) {comments.insert(0, Comment(author: "Youssef Saad", comment: inputValue, likes: 0, liked: false));},
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: 'Add comment...',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  filled: true,
                  fillColor: Colors.grey[800],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(100.0),
                  )),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      )),
    ));
  }
}
