import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'e_button.dart';
import 'edit_text.dart';

// ignore: must_be_immutable
class BottomSheetStudent extends StatefulWidget {
  BottomSheetStudent({super.key, required this.data, required this.index});
  List<QueryDocumentSnapshot<Object?>>? data;
  int index;

  @override
  State<BottomSheetStudent> createState() => _BottomSheetStudentState();
}

class _BottomSheetStudentState extends State<BottomSheetStudent> {
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> Gkey = GlobalKey();
  var name = TextEditingController(),
      password = TextEditingController(),
      email = TextEditingController(),
      loading = false;

  addStudent() async {
    if (!Gkey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = !loading;
    });

    try {
      var auth = FirebaseAuth.instance;
      if (password.text != 'G') {
        await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(password.text == 'G'
              ? widget.data![widget.index].id
              : auth.currentUser!.uid)
          .set({
        'name': name.text,
        'password': password.text,
        'email': email.text,
        'user': true
      });
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.data![widget.index].id)
          .delete();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Student added')));
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    if (widget.data!.isNotEmpty) {
      name.text = widget.data![widget.index]['name'];
      password.text = widget.data![widget.index]['password'];
      email.text = widget.data![widget.index]['email'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      height: double.infinity,
      child: Form(
        key: Gkey,
        child: Column(
          children: [
            const Text(
              'Add new student',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            EditTextFiled(
              hint: 'Student name',
              icon: Icons.person,
              controller: name,
              secure: false,
              validator: (val) {
                if (val!.isEmpty) return 'Please enter a student name';
                return null;
              },
            ),
            EditTextFiled(
              hint: 'Student email',
              icon: Icons.email,
              controller: email,
              secure: false,
              validator: (val) {
                if (val!.isEmpty) return 'Please enter a student email';
                return null;
              },
            ),
            EditTextFiled(
                hint: 'Student password',
                icon: Icons.password,
                controller: password,
                secure: false,
                validator: null),
            const SizedBox(
              height: 50,
            ),
            loading
                ? const CircularProgressIndicator()
                : EButton(title: 'Add', function: addStudent)
          ],
        ),
      ),
    );
  }
}
