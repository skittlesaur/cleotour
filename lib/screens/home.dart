import 'package:flutter/cupertino.dart';
import 'package:cleotour/widgets/common/navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const NavigationBar();
  }
}
