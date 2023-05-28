import 'package:cleotour/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  Function(bool) updateAuthenticationStatus;
  @override
  LoginScreen({super.key, required this.updateAuthenticationStatus});

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
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: NetworkImage("https://i.imgur.com/9avScxF.png"),
              fit: BoxFit.cover,
            )),
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                  color: Colors.black,
                  child: Container(
                    margin: const EdgeInsets.only(top: 200),
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            const Text(
                              "Cleotours",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 36),
                            ),
                            if (authenticationMode == 1)
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 20),
                                child: Container(
                                  width: 400,
                                  child: const Text(
                                    "Username",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            if (authenticationMode == 1)
                              Container(
                                width: 400,
                                child: Container(
                                  color: Colors.black,
                                  child: TextField(
                                    controller: _usernameController,
                                    style: const TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                        labelText: "Enter a username",
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    47, 47, 48, 1)),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.grey)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never),
                                  ),
                                ),
                              ),
                            Container(
                              width: 400,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 20),
                                child: Container(
                                  width: 400,
                                  child: const Text(
                                    "Email",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: Container(
                                color: Colors.black,
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                      labelText: "Enter an Email",
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  47, 47, 48, 1)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, top: 20),
                              child: Container(
                                width: 400,
                                child: const Text(
                                  "Password",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: Container(
                                color: Colors.black,
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                      labelText: "Enter a password",
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  47, 47, 48, 1)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              padding: const EdgeInsets.only(top: 20),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.amber,
                                    width: 1,
                                  ),
                                ),
                                onPressed: () {
                                  loginORsignup();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: ((authenticationMode == 1)
                                      ? const Text(
                                          "Sign up",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                ),
                              ),
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
                  )),
            )));
  }

  void loginORsignup() async {
    try {
      if (authenticationMode == 1) // sign up
      {
        if (_emailController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _usernameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all fields.'),
            ),
          );
        } else {
          await register();
          widget.updateAuthenticationStatus(true);
        }
      } else //log in
      {
        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all fields.'),
            ),
          );
        } else {
          signIn();
          widget.updateAuthenticationStatus(true);
        }
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
