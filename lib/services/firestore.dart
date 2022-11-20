import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  var instance = FirebaseFirestore.instance.collection("trees").doc();
  CollectionReference instance2 =
      FirebaseFirestore.instance.collection("trees");

  addTree(id, name, needOfWatring,lastWatring, DateTime datePlant, latlong) {
    instance.set({
      "id": instance.id,
      "name": name,
      "needOfWatring": needOfWatring,
      "lastWatring":lastWatring,
      "datePlant": datePlant,
      "address": latlong,
    });
  }

  updateTree(treeid, needOfWatring,lastWatring) {
    instance2.doc(treeid).update({
      "needOfWatring": needOfWatring,
      "lastWatring":lastWatring
    });
  }
  updatestat(treeid, needOfWatring,) {
    instance2.doc(treeid).update({
      "needOfWatring": needOfWatring,
      
    });
  }
}
