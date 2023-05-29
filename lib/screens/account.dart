import 'package:cleotour/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatelessWidget {
  Function(bool) updateAuthenticationStatus;
  AccountScreen({super.key, required this.updateAuthenticationStatus});
  User? currentUser = Auth().getCurrentUser();
  void signOutAndChangeIndex() {
    Auth().signOut();
    updateAuthenticationStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .where('posterId', isEqualTo: currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                final posts = snapshot.data!.docs;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final postData =
                        posts[index].data() as Map<String, dynamic>;

                    // Extract the necessary fields from the postData map
                    final postTitle = postData['body'];
                    print(postTitle);
                    final postContent = postData['posterUserName'];
                    print(postContent);
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(postTitle),
                            subtitle: Text(postContent),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const Text('No posts found.');
            },
          ),
        ));
  }
}
