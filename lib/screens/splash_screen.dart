import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plantit/screens/register_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getData() async {
    var user = FirebaseAuth.instance.currentUser?.uid;
    await Future.delayed(const Duration(milliseconds: 3500));
   
    if (user == null) {
      Get.off(() => const RegisterScreen());
    } else {
      Get.off(() => const HomeScreen());
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset('assets/lotties/splash.json', repeat: false)),
    );
  }
}
