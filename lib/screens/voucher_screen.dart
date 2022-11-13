import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/list_tile_voucher.dart';
import 'package:plantit/components/voucher_card.dart';

class VoucherScreen extends StatefulWidget {
  VoucherScreen({super.key, required this.points});
  int points;

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  var id;

  changeState(x) {
    setState(() {
      id = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                if (id == null) {
                  Get.back();
                } else {
                  id = null;
                }
              });
            },
          ),
        ),
        body: id != null
            ? VoucherListTile(id: id, points: widget.points)
            : VoucherCard(
                function: changeState,
              ));
  }
}
