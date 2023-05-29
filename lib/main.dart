import 'package:cleotour/auth.dart';
import 'package:cleotour/screens/account.dart';
import 'package:cleotour/screens/auth_Screen.dart';
import 'package:cleotour/screens/favorites.dart';
import 'package:cleotour/widgets/bottom-navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/add-post.dart';
import 'screens/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     appId: '1:277688353042:android:95f586db4aa1556a3a33cb',
      //     apiKey: 'AIzaSyBha9BBSHOLFjkIBuKJOCinYYWCOqUV2Gk',
      //     projectId: 'cleotour-8bd53',
      //     messagingSenderId: '277688353042',
      //     storageBucket: 'cleotour-8bd53.appspot.com/'),
      );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  void changeIndex(int index) {
    setState(() {
      if (index >= 0 && index < _screens.length) {
        _currentIndex = index;
      }
    });
  }

  void updateAuthenticationStatus(bool isLoggedIn) {
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  List<Widget> _screens = [];

  @override
  Widget build(BuildContext context) {
    _screens = [
      HomeScreen(),
      AddPostScreen(),
      FavoritesScreen(),
      getAccountOrLoginScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleoTour',
      home: Scaffold(
        bottomNavigationBar: BottomNavigation(
          currentIndex: _currentIndex,
          onTap: changeIndex,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
      ),
    );
  }

  Widget getAccountOrLoginScreen() {
    if (_isLoggedIn) {
      return AccountScreen(
          updateAuthenticationStatus: updateAuthenticationStatus);
    } else {
      return LoginScreen(
          updateAuthenticationStatus: updateAuthenticationStatus);
    }
  }
}
