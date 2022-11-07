import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/edit_text.dart';
import 'package:plantit/services/fireStore.dart';
import 'package:unicons/unicons.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? currentLocation;

  var longitude;
  var latitude;
  GoogleMapController? gController;

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  late StreamSubscription<Position> serviceStatusStream;

  Future getPermission() async {
    bool sevices = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (sevices != true) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Services Not Enabled")));
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<void> getLatAndLong() async {
    currentLocation =
        await Geolocator.getCurrentPosition().then((value) => value);
    latitude = currentLocation!.latitude;
    longitude = currentLocation!.longitude;
    setState(() {});
  }

  CameraPosition _kGooglePlex(latitude, longitude) {
    return CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
  }

  setMarkerImage() async {
    myMarkers.add(
      Marker(
          markerId: MarkerId("value 2"),
          position: LatLng(37.4219983, -120.084),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration.empty, "images/RedTreePang")),
    );
  }

  Set<Marker> myMarkers = {
    Marker(
        markerId: MarkerId("value 1"),
        position: LatLng(37.4219983, -122.084),
        infoWindow: InfoWindow(title: "value 1"))
  };

  @override
  void initState() {
    getPermission();
    getLatAndLong();
    serviceStatusStream =
        Geolocator.getPositionStream().listen((Position? position) {
      // print(position == null
      //     ? 'Unknown'
      //     : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
    // setMarkerImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          markers: myMarkers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex(latitude, longitude),
          onMapCreated: (GoogleMapController controller) {
            gController = controller;
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // List<Placemark> placemarks =
          //     await placemarkFromCoordinates(latitude, longitude);
          // print(placemarks[0].locality);

          // gController?.animateCamera(
          //     CameraUpdate.newLatLng(LatLng(latitude, longitude)));

          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Column(
                children: [
                  const Text(
                    'Tree',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  EditTextFiled(
                    hint: 'Id',
                    icon: Icons.text_fields_outlined,
                    controller: idController,
                    secure: false,
                  ),
                  EditTextFiled(
                    hint: 'Name',
                    icon: Icons.text_fields_outlined,
                    controller: nameController,
                    secure: false,
                  ),
                  EButton(
                    title: 'Add',
                    function: () {
                      setState(() {});
                      DateTime dateToday = DateTime.now();

                      FireStoreServices().addTree(
                          idController.text,
                          nameController.text,
                          "low",
                          dateToday.toString(),
                          latitude,
                          longitude);

                      idController.clear();
                      nameController.clear();
                      Navigator.pop(context);
                    },
                    h: 50,
                    w: 150,
                  )
                ],
              );
            },
          );
        },
        label: Row(
          children: [
            Icon(UniconsLine.shovel),
            SizedBox(
              width: 10,
            ),
            Text("Plant")
          ],
        ),
      ),
    );
  }
}
