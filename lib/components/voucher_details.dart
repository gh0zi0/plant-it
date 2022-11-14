import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/e_button.dart';

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
  int result = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.list![widget.index]['description'],
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
                  child: Text(
                    'Category: ${widget.category}',
                    style: const TextStyle(fontSize: 18),
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Location: ${widget.list![widget.index]['location']}',
                    style: const TextStyle(fontSize: 18),
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone number: ${widget.list![widget.index]['phone']}',
                    style: const TextStyle(fontSize: 18),
                  )),
              EButton(
                  title: 'redeem',
                  function: () async {
                    if (widget.points < widget.list![widget.index]['cost']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('redeemless').tr()));
                    } else {
                      setState(() {
                        result = widget.points -
                            int.parse(widget.list![widget.index]['cost']);
                      });
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({'points': result});
                      print(result.toString());
                    }
                  },
                  h: 50,
                  w: 200)
            ]),
          ),
        ),
      ),
    );
  }
}
