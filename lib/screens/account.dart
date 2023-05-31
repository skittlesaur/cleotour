import 'package:cleotour/services/posts.dart';
import 'package:cleotour/services/storage.dart';
import 'package:cleotour/services/users.dart';
import 'package:cleotour/widgets/account/account-menu.dart';
import 'package:cleotour/widgets/account/open-post.dart';
import 'package:cleotour/widgets/account/user-posts.dart';
import 'package:cleotour/widgets/account/user-side.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/post.dart';

class AccountScreen extends StatefulWidget {
  Function(bool) updateAuthenticationStatus;

  @override
  AccountScreen({super.key, required this.updateAuthenticationStatus});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final StorageService _storageService = StorageService();
  final PostsServices _postsServices = PostsServices();
  final UsersService _usersService = UsersService();
  Post? _openPost;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _usersService.getCurrentUser();
  }

  Future<void> deletePost(Post post) async {
    try {
      await _postsServices.deletePost(post.id);
      await _storageService.deleteImage(post.imageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete post")),
      );
    }
  }

  void signOutAndChangeIndex() {
    _usersService.signOut();
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: (currentUser == null)
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UserSide(currentUser: currentUser),
                            AccountMenu(
                                signOutAndChangeIndex: signOutAndChangeIndex)
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
                      UserPosts(
                        openPost: openPost,
                        currentUser: currentUser,
                      )
                    ],
                  ),
                  // if the user clicks on the image, this will show up
                  if (_openPost != null)
                    OpenPost(
                      openPost: _openPost!,
                      currentUser: currentUser,
                      deletePost: deletePost,
                      closePost: () {
                        setState(() {
                          _openPost = null;
                        });
                      },
                    )
                ],
              ),
      ),
    );
  }
}
