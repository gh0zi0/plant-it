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
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    image: data['image'].toString().isNotEmpty
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(data['image']))
                        : null,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 1)),
                child: data['image'].toString().isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 75,
                      )
                    : null,
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
