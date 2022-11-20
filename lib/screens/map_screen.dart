import 'dart:async';
import 'dart:ui';
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
import 'package:plantit/components/row_text.dart';
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
    String need = val["needOfWatring"].toString();

    setTreeStat(wataringDate, val);

    String imag = 'assets/images/GreenTree.png';

    if (need == "low") {
      imag = 'assets/images/GreenTree.png';
    } else if (need == "medium") {
      imag = 'assets/images/OrangeTree.png';
    } else if (need == "high") {
      imag = 'assets/images/RedTree.png';
    }

    final Uint8List markerIcon = await MapUtils().getBytesFromAsset(imag, 80);

    var markerIdval = specifyId;
    MarkerId markerId = MarkerId(markerIdval);
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(markerlatitude, markerlongitude),
      onTap: () {
        bool inUser = MapUtils().detectIfMarkerWithinBoundary(
            markerlatitude,
            markerlongitude,
            currentLocation1!.latitude,
            currentLocation1!.longitude);

        Get.defaultDialog(
            title: '',
            content: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Image.asset("assets/images/treeimage.png"),
                  const SizedBox(height: 15),
                  RowText(
                      t1: 'plantD',
                      t2: ': ${plantDate.year} / ${plantDate.month} / ${plantDate.day}',
                      alignment: MainAxisAlignment.start),
                  RowText(
                      t1: 'lastWatring',
                      t2: ': ${wataringDate.year} / ${wataringDate.month} / ${wataringDate.day}',
                      alignment: MainAxisAlignment.start),
                  RowText(
                      t1: 'need',
                      t2: ': ${tr(need)}',
                      alignment: MainAxisAlignment.start),
                  const SizedBox(height: 15),
                  RowText(
                      t1: 'plantBy',
                      t2: ': ${val["Planted by"]}',
                      alignment: MainAxisAlignment.start),
                  const SizedBox(height: 5),
                  inUser
                      ? ElevatedButton.icon(
                          onPressed: () {
                            FireStoreServices()
                                .updateTree(val["id"], "low", DateTime.now());
                            FireStoreServices().takePoint();
                             FireStoreServices().updateWater();

                          },
                          label: const Text("water").tr(),
                          icon: const Icon(UniconsLine.tear),
                        )
                      : const SizedBox()
                ],
              ),
            ));
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
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("select").tr(),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Icon(
                UniconsLine.exclamation_circle,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: currentLocation1 == null
            ? const Center(child: CircularProgressIndicator())
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        height: MediaQuery.of(context).size.height / 7.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "lets",
              style: TextStyle(fontSize: 16),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            EButton(
                title: "start",
                function: () {
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
                              FireStoreServices().updatePlant();

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
                h: 50,
                w: MediaQuery.of(context).size.width / 1.3),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
