import 'package:cleotour/model/post.dart';
import 'package:cleotour/widgets/common/comments-bottom-sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OpenPost extends StatelessWidget {
  final Post? openPost;
  final User? currentUser;
  final Function(Post) deletePost;
  final Function() closePost;

  const OpenPost(
      {Key? key,
      required this.openPost,
      required this.currentUser,
      required this.deletePost,
      required this.closePost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closePost();
      },
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            width: 350,
            height: 420,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade800,
                width: 1,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(openPost!.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser!.displayName!,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[400]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          openPost!.body,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                                (openPost!.rating != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          openPost!.rating.toString() + '.0',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  195, 197, 200, 1),
                                              fontFamily: 'Inter',
                                              fontSize: 15),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          "0.0",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  195, 197, 200, 1),
                                              fontFamily: 'Inter',
                                              fontSize: 15),
                                        ),
                                      ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        )),
                                        builder: (_) =>
                                            CommentsPage(postId: openPost!.id),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.chat_bubble_rounded,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.black,
                                          title: Text("Delete",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          content: Text(
                                              "Are you sure you want to delete?",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  deletePost(openPost!);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.red))),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
