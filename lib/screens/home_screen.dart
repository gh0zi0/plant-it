import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantit/screens/register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(
        title: const Text('home'),
        leading: IconButton(
          icon: const Icon(Icons.power_settings_new),
          onPressed: () => Get.off(() => const RegisterScreen()),
        ),
      ),
      // body: GoogleMap(
      //     onMapCreated: _onMapCreated,
      //     initialCameraPosition: CameraPosition(
      //       target: _center,
      //       zoom: 11.0,
      //     ),
      //   ),
    );
  }
}
