import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'e_button.dart';

// ignore: must_be_immutable
class CardPost extends StatelessWidget {
  CardPost({super.key, required this.function});
  Function function;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          Container(
              height: 175,
              width: double.infinity,
              color: const Color(0xFFE8F3ED),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 30, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'afaneen',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF009345),
                          fontWeight: FontWeight.bold),
                    ).tr(),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 175,
                      child: const Text(
                        'green',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EButton(
                        size: 14,
                        color: Colors.white,
                        tColor: const Color(0xFF009345),
                        title: 'start',
                        function: function,
                        h: 30,
                        w: 100),
                  ],
                ),
              )),
          Positioned(
            top: 55,
            right: 70,
            child: Image.asset(
              'assets/images/tree.png',
              height: 135,
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: Image.asset(
              'assets/images/tree.png',
              height: 175,
            ),
          ),
        ],
      ),
    );
  }
}
