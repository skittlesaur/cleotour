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
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    AddPostScreen(),
    FavoritesScreen(),
    (Auth().getCurrentUser() == null) ? LoginScreen() : AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleoTour',
      home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    );
  }
}
