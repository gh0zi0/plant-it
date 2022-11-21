import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantit/components/row_text.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';
import 'package:unicons/unicons.dart';
import '../screens/register_screen.dart';
import '../services/functions.dart';
import '../services/restart_app.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({super.key});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  var user = FirebaseAuth.instance,
      store = FirebaseFirestore.instance,
      dark = Get.isDarkMode,
      get = Get.put(Functions());
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: RowText(
                t1: 'hello',
                t2: user.currentUser!.displayName.toString(),
                alignment: MainAxisAlignment.start,
              ),
            ),
            const Divider(
              color: Color(0xFF009345),
              thickness: 0.2,
            ),
            ListTile(
              trailing: const Icon(Icons.language),
              title: const Text('changeLan').tr(),
              onTap: () {
                if (context.locale.toString() != 'ar') {
                  context.setLocale(const Locale('ar'));
                  RestartWidget.restartApp(context);
                } else {
                  context.setLocale(const Locale('en'));
                  RestartWidget.restartApp(context);
                }
              },
            ),
            ListTile(
              trailing: Icon(dark ? Icons.light_mode : Icons.dark_mode),
              title: Text(dark ? 'lightMode' : 'darkMode').tr(),
              onTap: () async {
                await ThemeModeBuilderConfig.toggleTheme();
                setState(() {
                  dark = !dark;
                });
              },
            ),
            ListTile(
              trailing: const Icon(Icons.share),
              title: const Text('share').tr(),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cooming soon')));
              },
            ),
            ListTile(
              trailing: const Icon(Icons.disabled_by_default_rounded),
              title: const Text('deleteAcc').tr(),
              onTap: get.dialogDelete,
            ),
            ListTile(
              trailing: const Icon(
                UniconsLine.power,
                color: Colors.red,
              ),
              title: const Text(
                'signout',
                style: TextStyle(color: Colors.red),
              ).tr(),
              onTap: () async {
                await user.signOut();
                await _googleSignIn.signOut();
                Get.off(() => const RegisterScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
