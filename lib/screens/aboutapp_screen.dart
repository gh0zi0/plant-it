import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  Future<void> launch(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        ListTile(
          title: const Text('FAQ').tr(),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        ListTile(
          title: const Text('privacy').tr(),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Uri _url = Uri.parse('https://sites.google.com/view/plantitx/home');
            launch(_url);
          },
        ),
        ListTile(
          title: const Text('report').tr(),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Uri url = Uri(
              scheme: 'mailto',
              path: 'zozotech@gmail.com',
            );
            launch(url);
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('facebook').tr(),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            // Uri _url = Uri.parse('https://flutter.dev');
            // launch(_url);
          },
        ),
        ListTile(
          title: const Text('insta').tr(),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            //   Uri _url = Uri.parse('https://flutter.dev');
            // launch(_url);
          },
        )
      ]),
    );
  }
}
