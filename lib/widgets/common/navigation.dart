import 'package:flutter/cupertino.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key, this.currentActive = 0}) : super(key: key);

  final int currentActive;

  static const List<String> _navigationItems = <String>[
    'Home',
    'Explore',
    'Likes',
    'Profile'
  ];

  static const List<IconData> _navigationIcons = <IconData>[
    CupertinoIcons.home,
    CupertinoIcons.search,
    CupertinoIcons.heart,
    CupertinoIcons.person
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Color(0xFF08080A),
        inactiveColor: Color(0xFFB6B7BA),
        // set active color to linear gradient color
        activeColor: Color(0xFFFFBF00),
        items: _navigationItems.map((String item) {
          return BottomNavigationBarItem(
            icon: Icon(_navigationIcons[_navigationItems.indexOf(item)]),
            label: item,
          );
        }).toList(),
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              child: Center(
                child: Text(_navigationItems[index]),
              ),
            );
          },
        );
      },
    );
  }
}
