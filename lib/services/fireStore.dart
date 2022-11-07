import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  CollectionReference instance = FirebaseFirestore.instance.collection("Trees");

  addTree(id, name, needOfWatring, datePlant, latlong) {
    instance.add({
      "id": id,
      "name": name,
      "needOfWatring": needOfWatring,
      "datePlant": datePlant,
      "address": latlong,
      
    });
  }
}
