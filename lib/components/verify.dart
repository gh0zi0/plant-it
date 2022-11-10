import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:plantit/components/t_button.dart';
import '../screens/home_screen.dart';
import 'e_button.dart';

// ignore: must_be_immutable
class Verify extends StatelessWidget {
  Verify({super.key, required this.email, required this.password});
  dynamic email, password;

  var user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'verify',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(
            height: 20,
          ),
          CountdownTimer(
            widgetBuilder: (context, time) {
              return time == null
                  ? TButton(
                      title: 'sendAgain',
                      function: () {
                        Get.back();
                        // verifyEmail(context);
                      })
                  : Text(
                      time.sec.toString(),
                      style: const TextStyle(fontSize: 25, color: Colors.green),
                    );
            },
            endTime: DateTime.now().millisecondsSinceEpoch + 60000,
          ),
          const SizedBox(
            height: 20,
          ),
          EButton(
              title: 'done',
              function: () async {
                await user.signInWithEmailAndPassword(
                    email: email.toString(), password: password.toString());

                if (user.currentUser!.emailVerified) {
                  Get.off(() => const HomeScreen());
                }
              },
              h: 40,
              w: 100)
        ],
      ),
    );
  }
}
