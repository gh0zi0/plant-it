import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyLottie extends StatelessWidget {
  const EmptyLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset('lottie/empty.json', height: 200, width: 200));
  }
}
