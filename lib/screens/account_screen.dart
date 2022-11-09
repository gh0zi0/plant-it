import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/acc_details.dart';
import 'package:plantit/components/e_button.dart';

import 'package:plantit/screens/register_screen.dart';
import 'package:unicons/unicons.dart';

import '../services/restart_app.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
        IconButton(
            onPressed: () {
              if (context.locale.toString() != 'ar') {
                context.setLocale(const Locale('ar'));
                RestartWidget.restartApp(context);
              } else {
                context.setLocale(const Locale('en'));
                RestartWidget.restartApp(context);
              }
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ))
      ]),
      body: Column(
        children: [
          const AccDetails(),
          const SizedBox(
            height: 25,
          ),
          const ListTile(
            leading: Icon(UniconsLine.ticket),
            title: Text('Vouchers'),
          ),
          const ListTile(
            leading: Icon(UniconsLine.comment_question),
            title: Text('Get help'),
          ),
          const ListTile(
            leading: Icon(UniconsLine.question_circle),
            title: Text('About app'),
          ),
          const SizedBox(
            height: 20,
          ),
          EButton(
              title: 'Sign Out',
              function: () {
                Get.off(() => const RegisterScreen());
                auth.signOut();
              },
              color: Colors.red,
              h: 50,
              w: 200)
        ],
      ),
    );
  }
}
