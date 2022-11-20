import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/row_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_widget/ticket_widget.dart';

// ignore: must_be_immutable
class Ticket extends StatelessWidget {
  Ticket(
      {super.key,
      required this.code,
      required this.shop,
      required this.points,
      required this.time});
  String code, shop, points;
  DateTime time;

  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      color: Colors.grey,
      width: 500,
      height: 325,
      isCornerRounded: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              RowText(
                  t1: 'theCode',
                  t2: ': $code',
                  alignment: MainAxisAlignment.center),
              const SizedBox(
                height: 10,
              ),
              RowText(
                  t1: 'time',
                  t2: ': ${DateFormat('dd/MM/yyyy , hh:mm').format(time)}',
                  alignment: MainAxisAlignment.center),
              const SizedBox(
                height: 10,
              ),
              RowText(
                  t1: 'yourPoints',
                  t2: ': $points',
                  alignment: MainAxisAlignment.center),
              const SizedBox(
                height: 10,
              ),
              RowText(
                  t1: 'shop',
                  t2: ': $shop',
                  alignment: MainAxisAlignment.center),
            ],
          ),
          QrImage(
            data: code,
            version: QrVersions.auto,
            size: 100,
          ),
        ],
      ),
    );
  }
}
