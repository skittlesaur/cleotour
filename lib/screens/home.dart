import 'package:flutter/material.dart';

import '../widgets/common/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var categoryValue = "Restaurant";
  Stream<QuerySnapshot<Object?>> getPosts() {
    return FirebaseFirestore.instance
        .collection("Posts")
        .where('category', isEqualTo: categoryValue)
        .snapshots();
    // .orderBy("postedAt", descending: true)
    // .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Recent",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              // Chip(
              //   elevation: 20,
              //   padding: EdgeInsets.all(8),
              //   backgroundColor: Colors.greenAccent[100],
              //   shadowColor: Colors.black,
              //   avatar: CircleAvatar(
              //     backgroundImage: NetworkImage(
              //         "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"), //NetworkImage
              //   ), //CircleAvatar
              //   label: Text(
              //     'GeeksforGeeks',
              //     style: TextStyle(fontSize: 20),
              //   ), //Text
              // )
              DropdownButton<String>(
                value: categoryValue,
                onChanged: (String? newValue) {
                  setState(() {
                    categoryValue = newValue!;
                  });
                },
                icon: Icon(Icons.format_list_bulleted_sharp),
                iconSize: 24.0,
                elevation: 16,
                underline: SizedBox(),
                items: ['Beach', 'Club', 'Museum', 'Restaurant']
                    .map((String item) {
                  return DropdownMenuItem<String>(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: getPosts(),
                builder: (ctx, strSnapshot) {
                  if (strSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var myDocuments = strSnapshot.data!.docs;

                  return ListView.builder(
                    itemBuilder: (itemCtx, index) {
                      var document = myDocuments[index].data() as Map;

                      return Post(
                        postId: document['postId'],
                        posterId: document['posterId'],
                        posterUserName: document['posterUserName'],
                        body: document['body'],
                        location: document['location'],
                        likes: document['likes'],
                        postedAt: document['postedAt'],
                        imageUrl: document['imageUrl'],
                        category: document['category'],
                      );
                    },
                    itemCount: myDocuments.length,
                  );
                }),
          )
        ],
      )),
    );
  }
}
