import 'package:cleotour/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cleotour/widgets/common/trendingSection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //   return const CupertinoApp(
  //     title: 'Cleotour',
  //     home: HomeScreen(),
  //   );
  // }

  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Cleotour',
      home: Scaffold(
        body: TrendingSection(),
        backgroundColor: Colors.black,
      ),
    );
  }
}
