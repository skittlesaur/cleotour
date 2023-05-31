import 'package:flutter/material.dart';

class AccountMenu extends StatelessWidget {
  final Function signOutAndChangeIndex;

  AccountMenu({required this.signOutAndChangeIndex});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade800)),
      itemBuilder: (context) => [
        // toggle between dark and light mode

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
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
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
    );
  }
}
