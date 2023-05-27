import 'package:flutter/material.dart';

import '../widgets/common/post.dart';
import 'package:cleotour/widgets/common/trendingSection.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [TrendingSection(), Post(), Post(), Post()],
      ))),
    );
  }
}
