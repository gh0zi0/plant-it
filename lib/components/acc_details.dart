import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../screens/voucher_screen.dart';

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
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Get.isDarkMode ? Colors.white : Colors.black)),
                child: data['image'].toString().isEmpty
                    ? Icon(
                        Icons.person,
                        size: 100,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: data['image'].toString(),
                          progressIndicatorBuilder: (context, x, url) =>
                              const Icon(
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
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                          ),
                          Image.asset(
                            'assets/images/can.png',
                            height: 35,
                          ),
                          Text(data['water'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
