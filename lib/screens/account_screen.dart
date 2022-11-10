import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantit/components/acc_details.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/screens/aboutapp_screen.dart';
import 'package:plantit/screens/help_screen.dart';
import 'package:plantit/screens/register_screen.dart';
import 'package:plantit/screens/voucher_screen.dart';
import 'package:unicons/unicons.dart';
import '../services/functions.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var auth = FirebaseAuth.instance, get = Get.put(Functions());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
        IconButton(
            onPressed: () {
              get.settingsDialog(context);
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
          ListTile(
            leading: const Icon(UniconsLine.ticket),
            title: const Text('voucher').tr(),
            onTap: () {
              Get.to(() => const VoucherScreen());
            },
          ),
          ListTile(
            leading: const Icon(UniconsLine.comment_question),
            title: const Text('help').tr(),
            onTap: () {
              // Get.to(() => const HelpScreen());
              // FirebaseAuth.instance.currentUser!.updateDisplayName('dqwd');
            
            },
          ),
          ListTile(
            leading: const Icon(UniconsLine.question_circle),
            title: const Text('aboutApp').tr(),
            onTap: () {
              Get.to(() => const AboutAppScreen());
            },
          ),
          const SizedBox(
            height: 20,
          ),
          EButton(
              title: 'signout',
              function: () async {
                await auth.signOut();
                await _googleSignIn.signOut();
                Get.off(() => const RegisterScreen());
              },
              color: Colors.red,
              h: 50,
              w: 200)
        ],
      ),
    );
  }
}
