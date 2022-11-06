import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  CollectionReference instance = FirebaseFirestore.instance.collection("Trees");

  addTree(id, name, needOfWatring, datePlant, latitude, longitude) {
    instance.add({
      "id": id,
      "name": name,
      "needOfWatring": needOfWatring,
      "datePlant": datePlant,
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
