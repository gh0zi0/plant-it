import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'functions.dart';

class FireStoreServices {
  CollectionReference instanceTree =
      FirebaseFirestore.instance.collection("trees");
  var instanceTree2 = FirebaseFirestore.instance.collection("trees").doc();
  CollectionReference instanceUser =
      FirebaseFirestore.instance.collection("users");

  FirebaseAuth auth = FirebaseAuth.instance;

  addTree(plantedBy, name, needOfWatring, DateTime datePlant, latlong) async {
    var url, get = Get.put(Functions()).imageFile;
    if (get != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('Trees/')
          .child(DateTime.now().toIso8601String());
      final result = await ref.putFile(get);
      url = await result.ref.getDownloadURL();
    }

    instanceTree2.set({
      "id": instanceTree2.id,
      "name": name,
      'image': url ?? '',
      "needOfWatring": needOfWatring,
      "lastWatring": datePlant,
      "datePlant": datePlant,
      "address": latlong,
      "Planted by": plantedBy
    });
    get = null;
    url = null;
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

  dePoint() {
    instanceUser
        .doc(auth.currentUser!.uid)
        .update({"dailyPoint": FieldValue.increment(-1)});
  }

  updateWater() {
    instanceUser
        .doc(auth.currentUser!.uid)
        .update({"water": FieldValue.increment(1)});
  }

  updatePlant() {
    instanceUser
        .doc(auth.currentUser!.uid)
        .update({"plants": FieldValue.increment(1)});
  }

  updateTimerPoint() async {
    var snapshot =
        await instanceUser.where("uid", isEqualTo: auth.currentUser!.uid).get();
    DateTime timer = snapshot.docs[0]["timer"].toDate();
    DateTime target = timer.add(const Duration(days: 1));

    DateTime daily = DateTime.now();

    if (daily.isAfter(target)) {
      //update the timer to now
      //reset the dailyPoint to 2
      instanceUser
          .doc(auth.currentUser!.uid)
          .update({"dailyPoint": 2, "timer": DateTime.now()});
    }
  }

  Future<int> get getData async {
    var x =
        await instanceUser.where("uid", isEqualTo: auth.currentUser!.uid).get();
    return x.docs[0]["dailyPoint"];
  }

  getUserUid() {
    return auth.currentUser!.uid;
  }

  getUserNmae() {
    return auth.currentUser!.displayName;
  }
}
