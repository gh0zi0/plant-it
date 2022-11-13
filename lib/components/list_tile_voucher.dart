import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'lottie_file.dart';

// ignore: must_be_immutable
class VoucherListTile extends StatelessWidget {
  VoucherListTile({super.key, required this.id});
  String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('vouchers')
          .doc(id)
          .collection('details')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final voucherData = snapshot.data?.docs;
          if (voucherData!.isEmpty) {
            return LottieFile(
              file: 'error',
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: voucherData.length,
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                leading: FittedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: voucherData[index]['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Icon(
                        UniconsLine.store,
                        size: 40,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        UniconsLine.store,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                title: Text(voucherData[index]['title']),
                trailing: const Icon(Icons.arrow_forward_ios),
                subtitle: Text(voucherData[index]['description']),
              );
            },
          );
        }
        return LottieFile(
          file: 'loading',
        );
      },
    );
  }
}
