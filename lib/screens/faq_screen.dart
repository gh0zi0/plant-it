import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/functions.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  var get = Get.put(Functions()), loading = true;

  getData(BuildContext context) {
    get.listFAQ(context);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: get.list.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(get.list[index]['q']),
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          get.list[index]['a'],
                          style: const TextStyle(fontSize: 14),
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
