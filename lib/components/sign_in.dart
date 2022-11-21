import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/t_button.dart';
import '../services/functions.dart';
import 'e_button.dart';
import 'edit_text.dart';

// ignore: must_be_immutable
class SignIn extends StatefulWidget {
  SignIn({super.key, required this.function});
  Function function;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> key = GlobalKey();
  var email = TextEditingController(),
      password = TextEditingController(),
      auth = FirebaseAuth.instance,
      focusE = FocusNode(),
      focusP = FocusNode(),
      loading = false,
      semail = tr('email'),
      spass = tr('password'),
      pemail = tr('pleaseEmail'),
      ppass = tr('pleasePass'),
      get = Get.put(Functions());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'welcome',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ).tr(),
                const SizedBox(
                  height: 20,
                ),
                EditTextFiled(
                  focus: focusE,
                  hint: semail,
                  icon: Icons.email,
                  controller: email,
                  secure: false,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return pemail;
                    }

                    return null;
                  },
                ),
                EditTextFiled(
                  focus: focusP,
                  hint: spass,
                  secure: true,
                  icon: Icons.password,
                  controller: password,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return ppass;
                    }
                    return null;
                  },
                ),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: TButton(
                        title: 'forgot',
                        function: () {
                          get.forgetPass(context);
                        })),
                const SizedBox(
                  height: 50,
                ),
                loading
                    ? const CircularProgressIndicator()
                    : EButton(
                        title: 'signIn',
                        function: () async {
                          setState(() {
                            loading = true;
                          });
                          await get.authentication(
                              context,
                              email.text,
                              password.text,
                              '',
                              key,
                              focusE,
                              focusP,
                              focusP,
                              false);
                          setState(() {
                            loading = false;
                          });
                        },
                        h: 55,
                        w: MediaQuery.of(context).size.width / 1.25,
                        color: const Color(0xFF009345),
                      ),
                const SizedBox(
                  height: 10,
                ),
                if (!loading)
                  SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await get.signInGoogle(context);
                          setState(() {
                            loading = false;
                          });
                        },
                        icon: Image.asset(
                          'assets/images/g.png',
                          height: 24,
                        ),
                        label: const Text('google').tr()),
                  ),
                TButton(title: 'dontHaveAcc', function: widget.function),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
