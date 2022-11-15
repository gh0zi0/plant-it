import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

class MapUtils{

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
  
}