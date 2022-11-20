import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../screens/voucher_screen.dart';
import 'lottie_file.dart';

class AccDetails extends StatelessWidget {
  const AccDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              CircleAvatar(
                radius: 76,
                backgroundColor: Colors.black,
                child: data['image'].toString().isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 100,
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: data['image'].toString(),
                          placeholder: (context, url) => const Icon(
                            Icons.person,
                            size: 100,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 100,
                          ),
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
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
              const SizedBox(
                height: 25,
              ),
              ListTile(
                leading: const Icon(UniconsLine.ticket),
                title: const Text('voucher').tr(),
                onTap: () {
                  Get.to(() => VoucherScreen(points: data['points']));
                },
              ),
            ],
          );
        }
        return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator());
      },
    );
  }
}
