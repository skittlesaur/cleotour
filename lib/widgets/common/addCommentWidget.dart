import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth.dart';
import '../../notifications/notification_service.dart';
import 'alertDialogWidget.dart';

class AddCommentWidget extends StatefulWidget {
  String postId;
  AddCommentWidget({required this.postId});

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  dynamic user = Auth().getCurrentUser();
  dynamic id = Auth().getCurrentUser()?.uid;

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
        'commenterUserName': Auth().getCurrentUser()?.displayName,
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
    final _textEditingController = TextEditingController();
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
          Expanded(
            child: TextField(
              onSubmitted: (inputValue) {
                if (id == null || user == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialogWidget(
                          title: "You are not signed in",
                          content: "Please sign in to leave a comment");
                    },
                  );
                  return;
                } else if (_textEditingController.text.isEmpty) {
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
                  addCommentToPost(widget.postId, _textEditingController.text);
                  setState(() {
                    NotificationService()
                        .showNotification(title: 'Comment Added');
                    _textEditingController.clear();
                  });
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
