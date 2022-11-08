import 'package:flutter/material.dart';

import 'e_button.dart';

class CardPost extends StatelessWidget {
   CardPost({super.key,required this.function});
   Function function;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.green.shade100,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/tree.png',
                height: 150,
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'هذه الارض تستحق الحياة',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'الطبيعة مصدر إلهامنا',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'لنحافظ عليها',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: EButton(
                        color: Colors.green,
                        title: 'إبدأ ',
                        function: function,
                        h: 30,
                        w: 100),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
