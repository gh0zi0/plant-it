import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/voucher_card.dart';
import '../components/lottie_file.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('vouchers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final voucherData = snapshot.data?.docs;

            if (voucherData!.isEmpty) {
              return LottieFile(
                file: 'error',
              );
            }
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: voucherData.length,
                itemBuilder: (context, index) {
                  return VoucherCard(
                    image: voucherData[index]['image'],
                  );
                },
              ),
            );
          }
          return LottieFile(
            file: 'loading',
          );
        },
      ),
    );
  }
}
