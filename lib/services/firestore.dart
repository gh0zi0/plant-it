import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServices {
  CollectionReference instanceTree =
      FirebaseFirestore.instance.collection("trees");
  CollectionReference instanceUser =
      FirebaseFirestore.instance.collection("users");

  FirebaseAuth auth = FirebaseAuth.instance;

  addTree(plantedBy, name, needOfWatring, DateTime datePlant, latlong) {
    instanceTree.doc(datePlant.millisecondsSinceEpoch.toString()).set({
      "id": datePlant.millisecondsSinceEpoch.toString(),
      "name": name,
      "needOfWatring": needOfWatring,
      "lastWatring": datePlant,
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
    DateTime target = timer.add(Duration(days: 1));

    DateTime daily = DateTime.now();

    if (daily.isAfter(target)) {
      //update the timer to now
      //reset the dailyPoint to 2
      instanceUser
          .doc(auth.currentUser!.uid)
          .update({"dailyPoint": 2, "timer": DateTime.now()});
    }
  }

  getData() async {
    
        await instanceUser.where("uid", isEqualTo: auth.currentUser!.uid).get();
    
  }


  getUserUid() {
    return auth.currentUser!.uid;
  }

  getUserNmae() {
    return auth.currentUser!.displayName;
  }
}
