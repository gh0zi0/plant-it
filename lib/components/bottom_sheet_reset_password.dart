import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'e_button.dart';
import 'edit_text.dart';

class BottomSheetReset extends StatefulWidget {
  const BottomSheetReset({super.key});

  @override
  State<BottomSheetReset> createState() => _BottomSheetResetState();
}

class _BottomSheetResetState extends State<BottomSheetReset> {
  final GlobalKey<FormState> key = GlobalKey();
  var loading = false,
      auth = FirebaseAuth.instance,
      email = TextEditingController();

  resetPass() async {
    if (!key.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        loading = true;
      });
      await auth.sendPasswordResetEmail(email: email.text);
      
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
       // ignore: use_build_context_synchronously
       ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Reset password sent to your email')));
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        height: double.infinity,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Reset your password',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
              EditTextFiled(
                  icon: Icons.email,
                  secure: false,
                  controller: email,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                  hint: 'Email'),
              const SizedBox(
                height: 20,
              ),
              loading
                  ? const CircularProgressIndicator()
                  : EButton(title: 'Submit', function: resetPass,h: 50,w: 150)
            ],
          ),
        ),
      ),
    );
  }
}
