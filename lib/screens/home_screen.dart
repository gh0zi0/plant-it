import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/screens/map_screen.dart';
import 'package:plantit/screens/post_screen.dart';
import 'package:plantit/screens/register_screen.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // late LatLng currentPostion;

  // void _getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance.getCurrentPosition();

  //   setState(() {
  //     currentPostion = LatLng(position.latitude, position.longitude);
  //   });

  //   print(currentPostion);
  // }

  //  late GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green.shade100,
      //   elevation: 0,
      // ),
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
        children: [PostScreen(), MapPage(), Text('3')],
      ),
    );
  }
}
