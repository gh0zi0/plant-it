import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:plantit/screens/account_screen.dart';
import 'package:plantit/screens/map_screen.dart';
import 'package:plantit/screens/post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        itemCornerRadius: 20,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.home_filled),
            title: const Text('Home'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.map),
            title: const Text(
              'Map',
            ),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Account'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children:const [PostScreen(), MapPage(), AccountScreen()],
      ),
    );
  }
}
