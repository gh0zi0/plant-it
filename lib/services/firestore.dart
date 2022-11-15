import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  var instance = FirebaseFirestore.instance.collection("Trees").doc();
  CollectionReference instance2 =
      FirebaseFirestore.instance.collection("Trees");

  addTree(id, name, needOfWatring, DateTime datePlant, latlong) {
    instance.set({
      "id": instance.id,
      "name": name,
      "needOfWatring": needOfWatring,
      "datePlant": datePlant,
      "address": latlong,
    });
  }

  updateTree(id, needOfWatring) {
    instance2.doc(id).update({
      "needOfWatring": needOfWatring,
    });
  }
}
