import 'package:cleotour/screens/account.dart';
import 'package:cleotour/screens/auth_Screen.dart';
import 'package:cleotour/screens/favorites.dart';
import 'package:cleotour/widgets/addpost/main.dart';
import 'package:cleotour/widgets/bottom-navigation.dart';
import 'package:cleotour/widgets/top-bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notifications/notification_service.dart';
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
  NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  bool _isAddingPost = false;

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
      _currentIndex = 0;
    });
  }

  void changeAddingPost(bool isAddingPost) {
    setState(() {
      _isAddingPost = isAddingPost;
    });
  }

// Background message handler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Message received in background: ${message.notification?.body}");
    // Handle the received message when the app is in the background
  }

  @override
  initState() {
    super.initState();
    final FirebaseMessaging fbm = FirebaseMessaging.instance;

    void initializeFirebaseMessaging() {
      fbm.requestPermission();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Message received: ${message.notification?.body}");
        // Handle the received message when the app is in the foreground
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Message opened app: ${message.notification?.body}");
        // Handle the received message when the app is in the background and opened
      });

      // For handling background messages (when the app is terminated or in the background)
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        updateAuthenticationStatus(false);
      } else {
        updateAuthenticationStatus(true);
      }
    });
  }

  List<Widget> _screens = [];

  @override
  Widget build(BuildContext context) {
    _screens = [
      HomeScreen(),
      FavoritesScreen(),
      getAccountOrLoginScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleoTour',
      home: Scaffold(
        bottomNavigationBar: BottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            // hide the add post page just in case
            changeAddingPost(false);
            // then change the index
            changeIndex(index);
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                _currentIndex != 2
                    ? TopBar(
                        changeAddingPost: changeAddingPost,
                        isAddingPost: _isAddingPost,
                        changeIndex: changeIndex,
                      )
                    : Container(),
                _isAddingPost
                    ? AddPost(
                        changeAddingPost: changeAddingPost,
                      )
                    : Expanded(
                        child: _screens[_currentIndex],
                      ),
              ],
            ),
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
      return AuthScreen(updateAuthenticationStatus: updateAuthenticationStatus);
    }
  }
}
