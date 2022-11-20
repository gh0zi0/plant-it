import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/edit_text.dart';
import 'package:plantit/components/lottie_file.dart';
import 'package:plantit/services/firestore.dart';
import 'package:plantit/services/functions.dart';
import 'package:plantit/services/map_utils.dart';
import 'package:unicons/unicons.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LocationData? currentLocation1;
  Location location = Location();

  // var loading = true;
  Completer<GoogleMapController> gController = Completer();

  TextEditingController nameController = TextEditingController();

  var get = Get.put(Functions());

  Future getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(val, specifyId) async {
    double markerlatitude = val["address"].latitude;
    double markerlongitude = val["address"].longitude;
    DateTime plantDate = val["datePlant"].toDate();
    DateTime wataringDate = val["lastWatring"].toDate();

    setTreeStat(wataringDate, val);

    String imag = 'assets/images/GreenTree.png';

    if (val["needOfWatring"] == "low") {
      imag = 'assets/images/GreenTree.png';
    } else if (val["needOfWatring"] == "medium") {
      imag = 'assets/images/OrangeTree.png';
    } else if (val["needOfWatring"] == "high") {
      imag = 'assets/images/RedTree.png';
    }

    final Uint8List markerIcon = await MapUtils().getBytesFromAsset(imag, 80);

    var markerIdval = specifyId;
    MarkerId markerId = MarkerId(markerIdval);
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(markerlatitude, markerlongitude),
      onTap: () {
        // gController?.animateCamera(CameraUpdate.newLatLngZoom(
        //     LatLng(markerlatitude, markerlongitude), 20.0));

        bool inUser = MapUtils().detectIfMarkerWithinBoundary(
            markerlatitude,
            markerlongitude,
            currentLocation1!.latitude,
            currentLocation1!.longitude);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  actions: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset("assets/images/treeimage.png"),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Plant : ${plantDate.year}/ ${plantDate.month} / ${plantDate.day}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  "lastWatring :  ${wataringDate.year}/ ${wataringDate.month} / ${wataringDate.day}",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 5),
                              Text("Need Of Water : ${val["needOfWatring"]}",
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text("Planted by : ${val["Planted by"]}",
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          inUser
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    FireStoreServices().updateTree(
                                        val["id"], "low", DateTime.now());
                                    FireStoreServices().takePoint();
                                  },
                                  label: const Text("Watring"),
                                  icon: const Icon(UniconsLine.tear),
                                )
                              : const SizedBox()
                        ],
                      ),
                    )
                  ]);
            });
      },
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkers() async {
    FirebaseFirestore.instance.collection("trees").snapshots().listen((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          for (int i = 0; i < value.docs.length; i++) {
            initMarker(value.docs[i].data(), value.docs[i].id);
          }
        }
      });
    });
  }

  getPosition() async {
    await location.getLocation().then(
      (location) {
        currentLocation1 = location;

        setState(() {});
      },
    );
  }

  getController() async {
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation1 = newLoc;

        setState(() {});
      },
    );
  }

  setTreeStat(wataringDate, val) {
    DateTime now = DateTime.now();

    var diff = now.difference(wataringDate).inDays;

    if (diff == 3) {
      FireStoreServices().updatestat(val["id"], "medium");
    } else if (diff == 5) {
      FireStoreServices().updatestat(val["id"], "high");
    } else if (diff > 5) {
      FireStoreServices().updatestat(val["id"], "high");
    }
  }

  @override
  void initState() {
    getPermission();
    getPosition();
    getController();
    getMarkers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select your tree to water"),
            SizedBox(
              width: 10,
            ),
            Icon(UniconsLine.tear)
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Icon(
                UniconsLine.exclamation_circle,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: currentLocation1 == null
            ? LottieFile(file: 'loading')
            : GoogleMap(
                mapType: MapType.normal,
                markers: Set<Marker>.of(markers.values),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentLocation1!.latitude!,
                      currentLocation1!.longitude!),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  gController.complete(controller);
                },
                circles: {
                    Circle(
                      circleId: const CircleId("1"),
                      center: LatLng(currentLocation1!.latitude!,
                          currentLocation1!.longitude!),
                      strokeWidth: 2,
                      radius: 10,
                      strokeColor: Colors.black54,
                      fillColor: Colors.blueGrey.shade100,
                    ),
                  }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  const SizedBox(
                    height: 20,
                  ),
                  EButton(
                    title: 'Add',
                    function: () {
                      DateTime dateToday = DateTime.now();

                      FireStoreServices().addTree(
                          currentLocation1,
                          FireStoreServices().getUserNmae(),
                          nameController.text,
                          "low",
                          dateToday,
                          dateToday,
                          GeoPoint(currentLocation1!.latitude!,
                              currentLocation1!.longitude!));
                      FireStoreServices().takePoint();

                      nameController.clear();
                      Navigator.pop(context);
                    },
                    h: 50,
                    w: 150,
                  ),
                ],
              );
            },
          );
        },
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
