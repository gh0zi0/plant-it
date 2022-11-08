import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/edit_text.dart';
import 'package:plantit/services/fire_store.dart';
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

  // setMarkerImage() async {
  //   myMarkers.add(
  //     Marker(
  //         markerId: MarkerId("value 2"),
  //         position: LatLng(37.4219983, -120.084),
  //         icon: await BitmapDescriptor.fromAssetImage(
  //             ImageConfiguration.empty, "images/RedTreePang")),
  //   );
  // }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void setMarker(lat, long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(markerId: markerId, position: LatLng(lat, long));
    setState(() {
      markers[markerId] = marker;
    });
  }

  void initMarker(specify, specifyId) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/GreenTree.png', 80);

    var markerIdval = specifyId;
    MarkerId markerId = MarkerId(markerIdval);
    Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify["address"].latitude, specify["address"].longitude),
      infoWindow: InfoWindow(title: specify["name"]),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    setState(() {
      markers[markerId] = marker;
    });
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

    // setMarkerImage();
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
                      DateTime dateToday = DateTime.now();
                      // setMarker(latitude, longitude);

                      FireStoreServices().addTree(
                          idController.text,
                          nameController.text,
                          "low",
                          dateToday.toString(),
                          GeoPoint(currentLocation!.latitude,
                              currentLocation!.longitude));

                      idController.clear();
                      nameController.clear();
                      Navigator.pop(context);
                      setState(() {
                        getMarkers();
                      });
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
