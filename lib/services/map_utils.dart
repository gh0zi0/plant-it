import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/edit_text.dart';
import 'dart:ui' as ui;

import 'package:plantit/services/firestore.dart';

class MapUtils {
  bool detectIfMarkerWithinBoundary(
      latitude1, longitude1, latitude2, longitude2) {
    bool inUser;
    double distance = Geolocator.distanceBetween(
        latitude1, longitude1, latitude2, longitude2);
//
    if (distance <= 10) {
      inUser = true;
    } else {
      inUser = false;
    }
    return inUser;
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

  String getImageMarkerUrl(need) {
    if (need == "low") {
      return 'assets/images/GreenTree.png';
    } else if (need == "medium") {
      return 'assets/images/OrangeTree.png';
    } else if (need == "high") {
      return 'assets/images/RedTree.png';
    } else {
      return 'assets/images/RedTree.png';
    }
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

  limitedPointDaily(dailyPoint) {
    if (dailyPoint > 0) {
      FireStoreServices().takePoint();
      FireStoreServices().dePoint();
    }
  }

  // void plantBottomSheet( context, currentLocation1) {
  //   TextEditingController nameController = TextEditingController();
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     backgroundColor: Colors.white,
  //     builder: (context) {
  //       return Column(
  //         children: [
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           const Text(
  //             'Plant',
  //             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //           ),
  //           EditTextFiled(
  //             hint: 'Name',
  //             icon: Icons.text_fields_outlined,
  //             controller: nameController,
  //             secure: false,
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           EButton(
  //             title: 'Add',
  //             function: () async {
  //             },
  //             h: 50,
  //             w: 150,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  
}
