// ignore_for_file: prefer_const_constructors

import 'package:cleotour/widgets/common/addCommentWidget.dart';
import 'package:cleotour/widgets/common/comment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  CommentsPage({required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late List<DocumentSnapshot> _commentsList;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>> getComments() {
      return FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .orderBy('postedAt', descending: true)
          .snapshots();
    }

    return Container(
        height: 500,
        decoration: BoxDecoration(
            color: Color.fromRGBO(32, 32, 33, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text("Comments",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getComments(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading comments'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var myDocuments = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: myDocuments.length,
                      itemBuilder: (itemCtx, index) {
                        var comment = myDocuments[index].data() as Map;

                        return Column(children: [
                          Comment(
                            postId: comment['postId'],
                            authorId: comment['commenterId'],
                            authorUserName: comment['commenterUserName'],
                            comment: comment['comment'],
                            postedAt: comment['postedAt'],
                            likes: comment['likes'],
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                  decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.4),
                                    width: 0.6,
                                  ),
                                ),
                              ))),
                        ]);
                      },
                    );
                  }),
            ),
            AddCommentWidget(
              postId: widget.postId,
            )
          ],
        ));
  }
}


// return Container(
//       height: 500,
//       decoration: BoxDecoration(
//           color: Color.fromRGBO(32, 32, 33, 1),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//           )),
//       child: Expanded(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: getComments(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error loading comments'),
//               );
//             }
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 16),
//                 Text("Comments",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500)),
//                 SizedBox(height: 16),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _commentsList.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot comment = _commentsList[index];
//                       return Column(children: [
//                         Comment(
//                           postId: comment['postId'],
//                           authorId: comment['commenterId'],
//                           authorUserName: comment['commenterUserName'],
//                           comment: comment['comment'],
//                           postedAt: comment['postedAt'],
//                           likes: comment['likes'],
//                         ),
//                         Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Container(
//                                 decoration: BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                   color: Colors.grey.withOpacity(0.4),
//                                   width: 0.6,
//                                 ),
//                               ),
//                             ))),
//                       ]);
//                     },
//                   ),
//                 ),
//                 AddCommentWidget(
//                   postId: widget.postId,
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
