import 'package:flutter/material.dart';

import '../widgets/common/post.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [Post(), Post(), Post()],
      ))),
    );
  }
}
