import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              color: Get.isDarkMode
                  ? const Color(0xFF424242)
                  : const Color(0xFFE8F3ED),
              child: Row(
                children: [
                  if (context.locale.toString() != 'en')
                    const Expanded(child: SizedBox()),
                  Container(
                    width: 225,
                    padding:
                        const EdgeInsets.only(right: 25, top: 25, left: 25),
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
                        SizedBox(
                          height: context.locale.toString() == 'en' ? 10 : 5,
                        ),
                        const Text(
                          'green',
                          style: TextStyle(
                              // color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ).tr(),
                        SizedBox(
                          height: context.locale.toString() == 'en' ? 20 : 5,
                        ),
                        EButton(
                            size: 14,
                            color: Get.isDarkMode
                                ? const Color(0xFF424242)
                                : const Color(0xFFE8F3ED),
                            tColor: const Color(0xFF009345),
                            title: 'start',
                            function: function,
                            h: 35,
                            w: 100),
                      ],
                    ),
                  ),
                  if (context.locale.toString() == 'en')
                    const Expanded(child: SizedBox()),
                ],
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
