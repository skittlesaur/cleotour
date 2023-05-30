import 'package:cleotour/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  Function(bool) updateAuthenticationStatus;

  AuthScreen({Key? key, required this.updateAuthenticationStatus})
      : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final authenticationInstance = FirebaseAuth.instance;
  String? errorMessage = '';

  bool _isSignup = false;

  void toggleAuthMode() {
    setState(() {
      _isSignup = !_isSignup;
    });
  }

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      widget.updateAuthenticationStatus(true);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong email or password'),
        ),
      );
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> register() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );
      widget.updateAuthenticationStatus(true);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong please try again later'),
        ),
      );
      setState(() {
        print(e.message);
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
            color: Colors.black,
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
              margin: EdgeInsets.only(top: 150),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Cleotour",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 36,
                        ),
                      ),
                      if (_isSignup) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 20),
                          child: Container(
                            width: 400,
                            child: const Text(
                              "Username",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: 400,
                          child: Container(
                            color: Colors.black,
                            child: TextFormField(
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
                                    color: Color.fromRGBO(47, 47, 48, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                      Container(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 20),
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
                          child: TextFormField(
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
                                  color: Color.fromRGBO(47, 47, 48, 1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 20),
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
                          child: TextFormField(
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
                                  color: Color.fromRGBO(47, 47, 48, 1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'password must be at least 7 characters';
                              }
                              return null;
                            },
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
                          onPressed: loginORsignup,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              _isSignup ? "Sign up" : "Login",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: toggleAuthMode,
                        child: Text(
                          _isSignup
                              ? "I already have an account"
                              : "Create account",
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void loginORsignup() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        if (_isSignup) {
          await register();
        } else {
          signIn();
        }
      } catch (err) {
        debugPrint(err.toString());
      }
    }
  }
}
