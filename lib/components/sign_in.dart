import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantit/components/t_button.dart';
import '../screens/home_screen.dart';
import '../services/functions.dart';
import 'bottom_sheet_reset_password.dart';
import 'e_button.dart';
import 'edit_text.dart';
import 'lottie_file.dart';

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
                  'Welcome',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                EditTextFiled(
                  focus: focusE,
                  hint: 'Email',
                  icon: Icons.email,
                  controller: email,
                  secure: false,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Enter valid email';
                    }

                    return null;
                  },
                ),
                EditTextFiled(
                  focus: focusP,
                  hint: 'Password',
                  secure: true,
                  icon: Icons.password,
                  controller: password,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter a password at least 6 characters';
                    }
                    return null;
                  },
                ),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: TButton(
                        title: 'Forgot password?',
                        function: () {
                          get.forgetPass(context);
                        })),
                const SizedBox(
                  height: 50,
                ),
                loading
                    ? LottieFile(file: 'loading')
                    : EButton(
                        title: 'Sign In',
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
                        label: const Text('Sign In with google')),
                  ),
                TButton(
                    title: 'Don\'t have account? Sign Up',
                    function: widget.function),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
