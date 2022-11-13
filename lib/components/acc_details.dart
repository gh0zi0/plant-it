import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
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
                  ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 1)),
                      child: data['image'].toString().isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 75,
                            )
                          : null,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: CachedNetworkImage(
                        height: 150,
                        imageUrl: data['image'],
                        placeholder: (context, url) => const Icon(Icons.person),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                      )),
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
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: Card(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            UniconsLine.trees,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text(data['plants'].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const VerticalDivider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          Image.asset(
                            'assets/images/can.png',
                            height: 35,
                          ),
                          Text(data['water'].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 60,
                    child: Card(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            UniconsLine.coins,
                            color: Colors.amberAccent,
                            size: 30,
                          ),
                          Text(
                            data['points'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
