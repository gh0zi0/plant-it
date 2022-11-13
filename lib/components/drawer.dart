import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/t_button.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';
import '../screens/register_screen.dart';
import '../services/restart_app.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({super.key});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  var user = FirebaseAuth.instance, store = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hello',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
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
            trailing: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            title: Text(Get.isDarkMode ? 'lightMode' : 'darkMode').tr(),
            onTap: () {
              ThemeModeBuilderConfig.toggleTheme();
              setState(() {});
            },
          ),
          ListTile(
            trailing: const Icon(Icons.share),
            title: const Text('share').tr(),
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Cooming soon')));
            },
          ),
          ListTile(
            trailing: const Icon(Icons.disabled_by_default_rounded),
            title: const Text('deleteAcc').tr(),
            onTap: () {
              Get.defaultDialog(
                  title: tr('sure'),
                  content: const Text(
                    'deleteAccM',
                    textAlign: TextAlign.center,
                  ).tr(),
                  confirm: TButton(
                      title: 'yes',
                      function: () async {
                        Get.off(() => const RegisterScreen());
                        await store
                            .collection('users')
                            .doc(user.currentUser!.uid)
                            .delete();
                        await user.currentUser!.delete();
                        user.signOut();
                      }),
                  cancel: TButton(
                      title: 'no',
                      function: () {
                        Get.back();
                      }));
            },
          ),
        ],
      ),
    );
  }
}
