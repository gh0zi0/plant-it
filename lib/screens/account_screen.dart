import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/acc_details.dart';
import 'package:plantit/components/card_acc.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/lottie_file.dart';
import 'package:plantit/screens/register_screen.dart';
import 'package:unicons/unicons.dart';

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
            onPressed: () {},
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
