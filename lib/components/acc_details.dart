import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'card_acc.dart';
import 'lottie_file.dart';

class AccDetails extends StatelessWidget {
  const AccDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              data['image'].toString().isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 100,
                    )
                  : ClipOval(
                      child: SizedBox.fromSize(
                          size: const Size.fromRadius(75),
                          child: CachedNetworkImage(
                            imageUrl: data['image'],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                          )),
                    ),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: Text(
                    data['name'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Container(
                  alignment: Alignment.center, child: Text(data['email'])),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CardAcc(
                    text: data['plants'].toString(),
                    icon: UniconsLine.trees,
                    color: Colors.green,
                  ),
                  CardAcc(
                    text: data['points'].toString(),
                    icon: UniconsLine.coins,
                    color: Colors.amber,
                  )
                ],
              ),
            ],
          );
        }
        return LottieFile(file: 'loading');
      },
    );
  }
}
