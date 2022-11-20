import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/functions.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  var get = Get.put(Functions()), list, loading = true;

  cw() async {
    list = await context.locale.toString() == 'ar' ? get.faqa : get.faqe;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // cw();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(list[index]['q']),
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          list[index]['a'],
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
