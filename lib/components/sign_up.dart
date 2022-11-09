import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/t_button.dart';
import '../services/functions.dart';
import 'e_button.dart';
import 'edit_text.dart';
import 'lottie_file.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  SignUp({super.key, required this.function});
  Function function;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> key = GlobalKey();
  var email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController(),
      auth = FirebaseAuth.instance,
      store = FirebaseFirestore.instance,
      focusE = FocusNode(),
      focusP = FocusNode(),
      focusN = FocusNode(),
      loading = false,
      semail = tr('email'),
      spass = tr('password'),
      sname = tr('name'),
      pemail = tr('pleaseEmail'),
      ppass = tr('pleasePass'),
      pname = tr('pleaseName'),
      get = Get.put(Functions());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'join',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ).tr(),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      get.getFromGallery();
                      setState(() {});
                    },
                    child: get.imageFile == null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 1)),
                            child: const Icon(
                              Icons.person,
                              size: 75,
                            ),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(
                              get.imageFile,
                            ))),
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
                EditTextFiled(
                  focus: focusN,
                  hint: sname,
                  secure: false,
                  icon: Icons.person,
                  controller: name,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return pname;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                loading
                    ? LottieFile(file: 'loading')
                    : EButton(
                        title: 'signUp',
                        function: () async {
                          setState(() {
                            loading = true;
                          });
                          await get.authentication(
                              context,
                              email.text,
                              password.text,
                              name.text,
                              key,
                              focusE,
                              focusP,
                              focusN,
                              true);
                          setState(() {
                            loading = false;
                          });
                        },
                        h: 50,
                        w: 200,
                        color: Colors.green,
                      ),
                const SizedBox(
                  height: 20,
                ),
                if (!loading)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          get.signInGoogle(context);
                        },
                        icon: Image.asset(
                          'assets/images/g.png',
                          height: 24,
                        ),
                        label: const Text('google').tr()),
                  ),
                TButton(title: 'alreadyHaveAcc', function: widget.function),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
