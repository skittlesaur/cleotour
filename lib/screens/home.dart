import 'package:flutter/material.dart';

import '../widgets/common/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common/trendingSection.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var categoryValue = "All";

  Stream<QuerySnapshot<Object?>> getPosts() {
    if (categoryValue == 'All') {
      return FirebaseFirestore.instance
          .collection("Posts")
          .orderBy("postedAt", descending: true)
          .snapshots();
    }
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
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              TrendingSection(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Recent",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                  DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Color.fromRGBO(255, 191, 0, 1),
                    focusColor: Colors.grey.shade900,
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
                    items: ['Beach', 'Club', 'Museum', 'Restaurant', 'All']
                        .map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.white),
                        ),
                        value: item,
                      );
                    }).toList(),
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Post(
                        postId: snapshot.data!.docs[index].id,
                        body: snapshot.data!.docs[index]['body'],
                        location: snapshot.data!.docs[index]['location'],
                        category: snapshot.data!.docs[index]['category'],
                        posterId: snapshot.data!.docs[index]['posterId'],
                        posterUserName: snapshot.data!.docs[index]
                            ['posterUserName'],
                        likes: snapshot.data!.docs[index]['likes'],
                        imageUrl: snapshot.data!.docs[index]['imageUrl'],
                        postedAt: snapshot.data!.docs[index]['postedAt'],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }
}
