import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_student.dart';


// ignore: must_be_immutable
class ListTileStudent extends StatelessWidget {
  ListTileStudent(
      {super.key, required this.list, required this.index, required this.newS});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index;
  bool newS;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const StadiumBorder(),
        child: ListTile(
          leading: const SizedBox(),
          onTap: () => newS
              ? showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return BottomSheetStudent(data: list, index: index);
                  },
                )
              : null,
          subtitle: Text(list![index]['email']),
          title: Text(list![index]['name']),
        ));
  }
}
