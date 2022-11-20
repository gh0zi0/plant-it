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
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4 / 2,
            ),
            itemCount: voucherData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                    onTap: () {
                      function(
                          voucherData[index].id, voucherData[index]['title']);
                    },
                    child: GridTile(
                        footer: Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 3,
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: GridTileBar(
                              title: Center(
                                child: Text(
                                  voucherData[index]['title'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            )),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: voucherData[index]['image'],
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, progress) => const Icon(
                              UniconsLine.store,
                              size: 100,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 100,
                            ),
                          ),
                        ))),
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
