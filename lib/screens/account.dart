import 'package:cleotour/auth.dart';
import 'package:cleotour/screens/auth_Screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  Function(bool) updateAuthenticationStatus;
  AccountScreen({required this.updateAuthenticationStatus});

  void signOutAndChangeIndex() {
    Auth().signOut();
    updateAuthenticationStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('account'),
            ElevatedButton(
              onPressed: signOutAndChangeIndex,
              child: Text('signout'),
            ),
          ],
        ),
      ),
    );
  }
}
