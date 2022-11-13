import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/e_button.dart';

class VoucherDetails extends StatelessWidget {
  VoucherDetails(
      {super.key,
      required this.list,
      required this.index,
      required this.points});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index, points;

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
                imageUrl: list![index]['image'],
                height: 200,
                fit: BoxFit.fitWidth,
              ),
              Text('${list![index]['cost']} points'),
              Text(list![index]['description']),
              Text(list![index]['content']),
              EButton(
                  title: 'redeem',
                  function: () {
                    if (points < list![index]['cost']) {
                      print('sorry');
                    } else {
                      print('wow');
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
