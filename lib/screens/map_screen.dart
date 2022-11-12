import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantit/MapUtils.dart';

import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/edit_text.dart';
import 'package:plantit/components/lottie_file.dart';
import 'package:plantit/services/firestore.dart';
import 'package:unicons/unicons.dart';

import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? currentLocation;

  var longitude, latitude, loading = true;
  GoogleMapController? gController;

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

//
  Future<void> getLatAndLong() async {
    currentLocation =
        await Geolocator.getCurrentPosition().then((value) => value);
    latitude = currentLocation!.latitude;
    longitude = currentLocation!.longitude;
    setState(() {});
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(val, specifyId) async {
    String imag = 'assets/images/GreenTree.png';
    if (val["needOfWatring"] == "high") {
      imag = 'assets/images/RedTree.png';
    } else if (val["needOfWatring"] == "medium") {
      imag = 'assets/images/OrangeTree.png';
    }

    final Uint8List markerIcon = await MapUtils().getBytesFromAsset(imag, 80);
    double markerlatitude = val["address"].latitude;
    double markerlongitude = val["address"].longitude;

    var markerIdval = specifyId;
    MarkerId markerId = MarkerId(markerIdval);
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(markerlatitude, markerlongitude),
      onTap: () {
        gController?.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(markerlatitude, markerlongitude), 20.0));

        bool inUser = MapUtils().detectIfMarkerWithinBoundary(
            markerlatitude,
            markerlongitude,
            currentLocation!.latitude,
            currentLocation!.longitude);
        if (inUser) {
          showDialog(
              context: context,
              builder: (context) {
                DateTime plantDate = val["datePlant"].toDate();
                return AlertDialog(actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "datePlant : ${plantDate.year}/ ${plantDate.month} / ${plantDate.day}"),
                      Text("needOfWatring : ${val["needOfWatring"]}"),
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: const Text("Watring"),
                        icon: Icon(UniconsLine.tear),
                      )
                    ],
                  )
                ]);
              });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("outside")));
        }
      },
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkers() async {
    await FirebaseFirestore.instance.collection("Trees").get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          initMarker(value.docs[i].data(), value.docs[i].id);
        }
      }
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getPermission();
    getLatAndLong();
    getMarkers();
    serviceStatusStream =
        Geolocator.getPositionStream().listen((Position? position) {
      currentLocation = position;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? LottieFile(file: 'loading')
            : GoogleMap(
                mapType: MapType.normal,
                markers: Set<Marker>.of(markers.values),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  gController = controller;
                },
                circles: {
                    Circle(
                        circleId: const CircleId("1"),
                        center: LatLng(currentLocation!.latitude,
                            currentLocation!.longitude),
                        strokeWidth: 2,
                        radius: 10,
                        strokeColor: Colors.black54,
                        fillColor: Colors.blueGrey.shade100),
                  }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: loading
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Plant',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        EditTextFiled(
                          hint: 'Name',
                          icon: Icons.text_fields_outlined,
                          controller: nameController,
                          secure: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        EButton(
                          title: 'Add',
                          function: () {
                            DateTime dateToday = DateTime.now();
                            // setMarker(latitude, longitude);

                            FireStoreServices().addTree(
                                currentLocation!.longitude +
                                    currentLocation!.latitude,
                                nameController.text,
                                "low",
                                dateToday,
                                GeoPoint(currentLocation!.latitude,
                                    currentLocation!.longitude));

                            nameController.clear();
                            Navigator.pop(context);
                            setState(() {
                              getMarkers();
                            });
                          },
                          h: 50,
                          w: 150,
                        ),
                      ],
                    );
                  },
                );
              },
              heroTag: null,
              label: Row(
                children: [
                  const Icon(UniconsLine.shovel),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("plant").tr()
                ],
              ),
            ),
    );
  }
}
