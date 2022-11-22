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
import 'package:plantit/components/bottom_sheet_plant.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/row_text.dart';
import 'package:plantit/services/firestore.dart';
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
  DateTime plantDate = DateTime.now(), wataringDate = DateTime.now();
  double markerlatitude = 0.0, markerlongitude = 0.0;
  String need = '', plantBy = '';
  bool selected = false;

  Completer<GoogleMapController> gController = Completer();

  Future getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(val, specifyId) async {
    markerlatitude = val["address"].latitude;
    markerlongitude = val["address"].longitude;
    plantDate = val["datePlant"].toDate();
    wataringDate = val["lastWatring"].toDate();
    need = val["needOfWatring"].toString();
    plantBy = val["Planted by"].toString();

    MapUtils().setTreeStat(wataringDate, val);
    String imag = MapUtils().getImageMarkerUrl(need);
    final Uint8List markerIcon = await MapUtils().getBytesFromAsset(imag, 80);

    MarkerId markerId = MarkerId(specifyId);
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(markerlatitude, markerlongitude),
      onTap: () {
        bool inUser = MapUtils().detectIfMarkerWithinBoundary(
            markerlatitude,
            markerlongitude,
            currentLocation1!.latitude,
            currentLocation1!.longitude);
        setState(() {
          selected = true;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'plantBy',
                              style: TextStyle(fontSize: 12),
                            ).tr(),
                            Text(
                              ' $plantBy:',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          '${plantDate.day}/${plantDate.month}/${plantDate.year}',
                          style: const TextStyle(fontSize: 12),
                        ).tr()
                      ],
                    ),
                    const SizedBox(height: 10),
                    RowText(
                        t1: 'lastWatring',
                        t2: '${wataringDate.day}/${wataringDate.month}/${wataringDate.year}',
                        size: 12,
                        alignment: MainAxisAlignment.spaceBetween),
                    const Divider(
                      height: 20,
                      thickness: 0.5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'need',
                          style: TextStyle(fontSize: 12),
                        ).tr()),
                    SliderTheme(
                      data: const SliderThemeData(
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 0)),
                      child: Slider(
                        activeColor: need == 'low'
                            ? Colors.green
                            : need == 'medium'
                                ? Colors.amber
                                : Colors.red,
                        value: need == 'low'
                            ? 1
                            : need == 'medium'
                                ? 0.5
                                : 0.25,
                        onChanged: (value) {},
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        EButton(
                            title: 'water',
                            size: 14,
                            function: () async {
                              var snap = await FireStoreServices().getData;
                              await FireStoreServices()
                                  .updateTree(val["id"], "low", DateTime.now());
                              await FireStoreServices().updateWater();
                              await MapUtils().limitedPointDaily(snap);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            h: 30,
                            w: 100),
                      ],
                    )
                  ],
                ),
              )),
        );
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

  @override
  void initState() {
    getPermission();
    getPosition();
    getController();
    getMarkers();
    FireStoreServices().updateTimerPoint();
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey.shade200,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      content: SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Column(children: [
                                const Text('Need of water'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/RedTree.png',
                                          height: 35,
                                          width: 35,
                                        ),
                                        Text(
                                          'High',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/OrangeTree.png',
                                            height: 35,
                                            width: 35),
                                        Text('Medium',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/GreenTree.png',
                                            height: 35,
                                            width: 35),
                                        Text('Low',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )
                              ]),
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text('Watering the tree',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Trees require more water initally then they do during their growth',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('First two weeks',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'the tree should be watered daily for the first tow weeks after planting',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('three to 12 weeks',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'every two or three days',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'then once a week, Irrigation will be required until the tree settles in its new location',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'after three years, rainwater will suffice.',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        ),
                      )),
                );
              },
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
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                markers: Set<Marker>.of(markers.values),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentLocation1!.latitude!,
                      currentLocation1!.longitude!),
                  zoom: 20,
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
        decoration: BoxDecoration(
            color: Get.isDarkMode ? const Color(0xFF424242) : Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        height: MediaQuery.of(context).size.height / 8.5,
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return BottomSheetPlant(
                        currentLocation: currentLocation1,
                      );
                    },
                  );
                },
                color: const Color(0xFF009345),
                h: 40,
                w: MediaQuery.of(context).size.width / 1.3),
          ],
        ),
      ),
    );
  }
}
