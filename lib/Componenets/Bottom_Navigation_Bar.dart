import 'package:climate_insight_ai/pages/discover_screen.dart';
import 'package:climate_insight_ai/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import '../pages/home_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({required this.index});
  final int index;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Color(0xFF12141E),
      height: 60,
      animationDuration: const Duration(seconds: 1),
      elevation: 0,
      onDestinationSelected: (int index) {
        setState(() {
          index;
        });
      },
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      surfaceTintColor: Colors.white,
      indicatorColor: Colors.white,
      selectedIndex: widget.index,
      destinations: [
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.home,
            size: 27.0,
          ),
          icon: IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen())),
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.view_list,
            size: 27.0,
          ),
          icon: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DiscoverScreen())),
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.white,
            ),
          ),
          label: 'Discover',
        ),
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.settings,
            size: 27.0,
          ),
          icon: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen())),
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
