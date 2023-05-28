import 'dart:convert';
import 'package:cleotour/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final authenticationInstance = FirebaseAuth.instance;
  String? errorMessage = '';
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

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> register() async {
    try {
      Auth().createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 400,
        margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
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
                    "Cleotours",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Password"),
                  controller: _passwordController,
                  obscureText: true,
                ),
                if (authenticationMode == 1)
                  TextField(
                    decoration: InputDecoration(labelText: "Username"),
                    controller: _usernameController,
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
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();
    var username = _usernameController.text.trim();
    UserCredential authResult;
    try {
      if (authenticationMode == 1) // sign up
      {
        await register();
      } else //log in
      {
        await signIn();
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
