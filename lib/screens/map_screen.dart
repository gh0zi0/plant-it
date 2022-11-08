import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/edit_text.dart';
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

  var longitude, latitude;
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

  Future<void> getLatAndLong() async {
    currentLocation =
        await Geolocator.getCurrentPosition().then((value) => value);
    latitude = currentLocation!.latitude;
    longitude = currentLocation!.longitude;
    setState(() {});
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(val, specifyId) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/GreenTree.png', 80);

    var markerIdval = specifyId;
    MarkerId markerId = MarkerId(markerIdval);
    Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(val["address"].latitude, val["address"].longitude),
      onTap: () {
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
                  ],
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

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getMarkers() async {
    await FirebaseFirestore.instance.collection("Trees").get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          initMarker(value.docs[i].data(), value.docs[i].id);
        }
      }
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
        child: GoogleMap(
          mapType: MapType.normal,
          markers: Set<Marker>.of(markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target:
                LatLng(currentLocation!.latitude, currentLocation!.longitude),
            zoom: 14.4746,
          ),
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
        label: Row(
          children: const [
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
