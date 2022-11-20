import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'lottie_file.dart';

// ignore: must_be_immutable
class VoucherCard extends StatelessWidget {
  VoucherCard({super.key, required this.function});
  Function function;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('vouchers').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final voucherData = snapshot.data?.docs;

          if (voucherData!.isEmpty) {
            return LottieFile(
              file: 'error',
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: voucherData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  function(voucherData[index].id, voucherData[index]['title']);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: 175,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: voucherData[index]['image'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Icon(
                            UniconsLine.store,
                            size: 100,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            UniconsLine.store,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                    Text(voucherData[index]['title'])
                  ],
                ),
              );
            },
          );
        }
        return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator());
      },
    );
  }
}
