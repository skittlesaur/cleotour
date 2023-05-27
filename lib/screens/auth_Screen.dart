import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  final authenticationInstance = FirebaseAuth.instance;
  var authenticationMode = 0;
  void toggleAuthMode() {
    if (authenticationMode == 0) {
      setState(() {
        authenticationMode = 1;
      });
    } else {
      setState(() {
        authenticationMode = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 400,
        margin: EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Class Chat",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Password"),
                  controller: passwordController,
                  obscureText: true,
                ),
                if (authenticationMode == 1)
                  TextField(
                    decoration: InputDecoration(labelText: "Username"),
                    controller: usernameController,
                  ),
                ElevatedButton(
                  onPressed: () {
                    loginORsignup();
                  },
                  child: (authenticationMode == 1)
                      ? const Text("Sign up")
                      : const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    toggleAuthMode();
                  },
                  child: (authenticationMode == 1)
                      ? const Text("Login instead")
                      : const Text("Sign up instead"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginORsignup() async {
    var email = emailController.text.trim();
    var password = passwordController.text.trim();
    var username = usernameController.text.trim();
    UserCredential authResult;
    try {
      if (authenticationMode == 1) // sign up
      {
        authResult =
            await authenticationInstance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      } else //log in
      {
        authResult = await authenticationInstance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
