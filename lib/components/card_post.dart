import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'e_button.dart';

// ignore: must_be_immutable
class CardPost extends StatelessWidget {
  CardPost({super.key, required this.function});
  Function function;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.green.shade100,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/tree.png',
                height: 150,
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'deserves',
                      style: TextStyle(fontSize: 22),
                    ).tr(),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'inspiration',
                      style: TextStyle(fontSize: 16),
                    ).tr(),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'keep',
                      style: TextStyle(fontSize: 16),
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: EButton(
                        color: Colors.green,
                        title: 'start',
                        function: function,
                        h: 30,
                        w: 100),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
