import 'package:cleotour/services/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesHeader extends StatefulWidget {
  @override
  State<FavoritesHeader> createState() => _FavoritesHeaderState();
}

class _FavoritesHeaderState extends State<FavoritesHeader> {
  final UsersService usersService = UsersService();
  User? currentUser;

  @override
  void initState() {
    currentUser = usersService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return currentUser != null
        ? const Text(
            'Favorites',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
          )
        : const Center(
            child: Text(
              'You are not logged in',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          );
  }
}
