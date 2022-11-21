import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/row_text.dart';
import 'package:unicons/unicons.dart';

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
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                            function: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => AlertDialog(
                              //       shape: const RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20.0))),
                              //       content: SingleChildScrollView(
                              //         child: SizedBox(
                              //           height:
                              //               MediaQuery.of(context).size.height /
                              //                   4,
                              //           child: Column(
                              //             children: [
                              //               RowText(
                              //                   t1: 'plantD',
                              //                   t2: ': ',
                              //                   alignment:
                              //                       MainAxisAlignment.start),
                              //               const SizedBox(height: 10),
                              //               RowText(
                              //                   t1: 'lastWatring',
                              //                   t2: ': ',
                              //                   alignment:
                              //                       MainAxisAlignment.start),
                              //               const SizedBox(height: 10),
                              //               RowText(
                              //                   t1: 'need',
                              //                   t2: ':',
                              //                   alignment:
                              //                       MainAxisAlignment.start),
                              //               const SizedBox(height: 10),
                              //               RowText(
                              //                   t1: 'plantBy',
                              //                   t2: ': ',
                              //                   alignment:
                              //                       MainAxisAlignment.start),
                              //               const SizedBox(height: 15),
                              //               Row(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.spaceEvenly,
                              //                 children: [
                              //                   EButton(
                              //                       title: 'water',
                              //                       function: () async {},
                              //                       h: 40,
                              //                       w: 150),
                              //                   IconButton(
                              //                     icon: const Icon(
                              //                       Icons.photo,
                              //                       size: 35,
                              //                       color: Color(0xFF009345),
                              //                     ),
                              //                     onPressed: () {},
                              //                   )
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       )),
                              // );
                            },
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
