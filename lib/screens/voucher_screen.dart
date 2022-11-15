import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/list_tile_voucher.dart';
import 'package:plantit/components/voucher_card.dart';

// ignore: must_be_immutable
class VoucherScreen extends StatefulWidget {
  VoucherScreen({super.key, required this.points});
  int points;

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  var id = '', category = '';

  changeState(idx, cat) {
    setState(() {
      id = idx;
      category = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(id == '' ? 'voucher' : category).tr(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                if (id == '') {
                  Get.back();
                } else {
                  id = '';
                }
              });
            },
          ),
        ),
        body: id != ''
            ? VoucherListTile(id: id, points: widget.points, category: category)
            : VoucherCard(
                function: changeState,
              ));
  }
}
