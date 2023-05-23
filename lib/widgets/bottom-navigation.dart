import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      items: <BottomNavigationBarItem>[
        _buildNavItem(0, Icons.home, 'Home'),
        _buildNavItem(1, Icons.auto_graph_rounded, 'Explore'),
        _buildNavItem(2, Icons.favorite, 'Favorites'),
        _buildNavItem(3, Icons.person, 'Account'),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      int index, IconData icon, String label) {
    final bool isActive = index == widget.currentIndex;
    final gradientColors = isActive
        ? [
            const Color.fromRGBO(166, 124, 0, 1),
            const Color.fromRGBO(255, 191, 0, 1),
            const Color.fromRGBO(255, 220, 115, 1)
          ] // gradient of active route
        : [Colors.white, Colors.white]; // gradient of inactive route

    return BottomNavigationBarItem(
      icon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
