import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';

class AddCommentWidget extends StatefulWidget {
  String postId;
  AddCommentWidget({required this.postId});

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  Future<void> addCommentToPost(String postId, String comment) async {
    try {
      CollectionReference _commentsCollection = FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection('Comments');

      var newCommentRef = await _commentsCollection.doc();

      await newCommentRef.set({
        'postId': newCommentRef.id,
        'commenterId': Auth().getCurrentUser()?.uid,
        'comment': comment,
        'postedAt': DateTime.now().toLocal().toString(),
        'likes': 0
      });
    } catch (error) {
      print('Error adding comment to post: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    String inputValue = _textEditingController.text;
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
              onSubmitted: (inputValue) {
                if (inputValue.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter a comment.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  comments.insert(
                      0,
                      Comment(
                          author: "Youssef Saad",
                          comment: inputValue,
                          likes: 0,
                          liked: false));
                  _textEditingController.clear();
                }
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: 'Add comment...',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  filled: true,
                  fillColor: Colors.grey[800],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
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

// List<Comment> comments = [
//   Comment(
//       author: "Youssef Saad",
//       comment:
//           "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
//       likes: 0,
//       liked: false),
//   Comment(
//       author: "Youssef Saad",
//       comment:
//           "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
//       likes: 0,
//       liked: false),
//   Comment(
//       author: "Youssef Saad",
//       comment:
//           "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
//       likes: 0,
//       liked: false),
//   Comment(
//       author: "Youssef Saad",
//       comment:
//           "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
//       likes: 0,
//       liked: false),
//   Comment(
//       author: "Youssef Saad",
//       comment:
//           "If vibrant colors, trendy cafes, and stunning views of the Nile are your thing, then Zamalek is the perfect place to explore. Just don't forget your sunglasses, you might need them to shield your eyes from all the colorful buildings! 😎🌈",
//       likes: 0,
//       liked: false)
// ];