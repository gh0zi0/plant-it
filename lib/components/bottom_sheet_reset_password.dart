import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/lottie_file.dart';
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
      focus1 = FocusNode(),
      auth = FirebaseAuth.instance,
      semail = tr('email'),
      pemail = tr('pleaseEmail'),
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
          .showSnackBar(SnackBar(content: const Text('sent').tr()));
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
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      height: double.infinity,
      child: Form(
        key: key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'resetPass',
              style: TextStyle(fontSize: 25),
            ).tr(),
            const SizedBox(
              height: 20,
            ),
            EditTextFiled(
                focus: focus1,
                icon: Icons.email,
                secure: false,
                controller: email,
                validator: (val) {
                  if (val!.isEmpty || !val.contains('@')) {
                    return pemail;
                  }
                  return null;
                },
                hint: semail),
            const SizedBox(
              height: 20,
            ),
            loading
                ? const CircularProgressIndicator()
                : EButton(
                    title: 'submit',
                    function: resetPass,
                    h: 50,
                    w: 150,
                    color: Colors.green,
                  )
          ],
        ),
      ),
    );
  }
}
