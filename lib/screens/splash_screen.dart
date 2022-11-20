import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/services/functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var get = Get.put(Functions());

  @override
  void initState() {
    get.auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: const Center(),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 5,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        child: const Text(
          'afaneen',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ).tr(),
      ),
    );
  }
}
