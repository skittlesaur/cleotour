import 'package:cleotour/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/post.dart';

class AccountScreen extends StatefulWidget {
  Function(bool) updateAuthenticationStatus;
  @override
  AccountScreen({super.key, required this.updateAuthenticationStatus});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var Image;
  final _storage = FirebaseStorage.instance;

  Future<String> downloadFile(String imageUrl) async {
    String downloadURL = await _storage.ref(imageUrl).getDownloadURL();
    Image = downloadURL;
    return downloadURL;
  }

  User? currentUser = Auth().getCurrentUser();
  Post? _openPost;

  void signOutAndChangeIndex() {
    Auth().signOut();
    widget.updateAuthenticationStatus(false);
  }

  void openPost(Post post) {
    setState(() {
      _openPost = post;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg"),
                                    radius: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser?.displayName ?? "",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        currentUser?.email ?? "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  // toggle between dark and light mode
                                  PopupMenuItem(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.dark_mode,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Dark Mode",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        signOutAndChangeIndex();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My Posts",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Posts")
                                .where('posterId', isEqualTo: currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.data!.docs.length == 0)
                                return Text(
                                  "You have not posted anything yet",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[400]),
                                );

                              // grid view of posts with just the image, when the user clicks on the image, it will get bigger and centered on the screen with the caption and the author's name similar to instagram
                              return GridView.builder(
                                itemCount: snapshot.data!.docs.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        openPost(Post(
                                          id: snapshot.data!.docs[index].id,
                                          imageUrl: snapshot.data!.docs[index]
                                              .get('imageUrl'),
                                          body: snapshot.data!.docs[index]
                                              .get('body'),
                                          userId: snapshot.data!.docs[index]
                                              .get('posterId'),
                                          category: snapshot.data!.docs[index]
                                              .get('category'),
                                        ));
                                      },
                                      child: FutureBuilder(
                                          future: downloadFile(snapshot
                                              .data!.docs[index]
                                              .get('imageUrl')),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Icon(Icons.error,
                                                  size: 100);
                                            } else {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }));
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // if the user clicks on the image, this will show up
                    if (_openPost != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _openPost = null;
                          });
                        },
                        child: Container(
                          color: Colors.black.withOpacity(0.8),
                          child: Center(
                            child: Container(
                              width: 350,
                              height: 400,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade800,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 300,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(Image ?? ""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          _openPost!.body,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ))));
  }
}

// Container(
//                                     height: 300,
//                                     width: 350,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: NetworkImage(
//                                             _openPost!.imageUrl ?? ""),
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
