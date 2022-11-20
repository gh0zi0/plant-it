import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServices {
  CollectionReference instanceTree =
      FirebaseFirestore.instance.collection("trees");
  CollectionReference instanceUser =
      FirebaseFirestore.instance.collection("users");

  FirebaseAuth auth = FirebaseAuth.instance;

  addTree(id, plantedBy, name, needOfWatring, lastWatring, DateTime datePlant,
      latlong) {
    instanceTree.doc().set({
      "id": instanceTree.id,
      "name": name,
      "needOfWatring": needOfWatring,
      "lastWatring": lastWatring,
      "datePlant": datePlant,
      "address": latlong,
      "Planted by": plantedBy
    });
  }

  updateTree(treeid, needOfWatring, lastWatring) {
    instanceTree
        .doc(treeid)
        .update({"needOfWatring": needOfWatring, "lastWatring": lastWatring});
  }

  updatestat(
    treeid,
    needOfWatring,
  ) {
    instanceTree.doc(treeid).update({
      "needOfWatring": needOfWatring,
    });
  }

// increment the points Field
  takePoint() {
    instanceUser
        .doc(auth.currentUser!.uid)
        .update({"points": FieldValue.increment(1)});
  }

  getUserUid() {
    return auth.currentUser!.uid;
  }

  getUserNmae() {
    return auth.currentUser!.displayName;
  }
}
