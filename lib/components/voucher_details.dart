import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/lottie_file.dart';
import 'package:plantit/components/row_text.dart';
import 'package:plantit/components/t_button.dart';
import 'package:plantit/components/ticket.dart';
import 'package:plantit/screens/home_screen.dart';

// ignore: must_be_immutable
class VoucherDetails extends StatefulWidget {
  VoucherDetails(
      {super.key,
      required this.list,
      required this.index,
      required this.points,
      required this.category});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index, points;
  String category;

  @override
  State<VoucherDetails> createState() => _VoucherDetailsState();
}

class _VoucherDetailsState extends State<VoucherDetails> {
  var loading = false;
  redeem() async {
    if (widget.points < widget.list![widget.index]['cost']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text('redeemless').tr()));
    } else {
      setState(() {
        loading = true;
      });
      int result = 0, cost, points;

      setState(() {
        cost = widget.list![widget.index]['cost'];
        points = widget.points;
        result = points - cost;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'points': result});
      setState(() {
        loading = false;
      });

      Get.defaultDialog(
          title: tr('yourCode'),
          confirm: TButton(
              title: 'ok',
              function: () async {
                Get.off(() => const HomeScreen());
              }),
          content: Ticket(
              code: widget.list![widget.index]['code'],
              shop: widget.list![widget.index]['title'],
              points: result.toString(),
              time: DateTime.now()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list![widget.index]['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  CachedNetworkImage(
                    imageUrl: widget.list![widget.index]['image'],
                    height: 200,
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.list![widget.index]['cost']} points',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.list![widget.index]['content'],
                        style: const TextStyle(fontSize: 18),
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 30),
                      alignment: Alignment.centerLeft,
                      child: RowText(
                        t1: 'category',
                        t2: widget.category,
                        alignment: MainAxisAlignment.start,
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: RowText(
                        t1: 'location',
                        t2: widget.list![widget.index]['location'],
                        alignment: MainAxisAlignment.start,
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      alignment: Alignment.centerLeft,
                      child: RowText(
                        t1: 'phone',
                        t2: widget.list![widget.index]['phone'],
                        alignment: MainAxisAlignment.start,
                      )),
                  loading
                      ? const CircularProgressIndicator()
                      : EButton(
                          title: 'redeem', function: redeem, h: 50, w: 200),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
