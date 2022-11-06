import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantit/components/t_button.dart';
import '../screens/home_screen.dart';
import 'e_button.dart';
import 'edit_text.dart';
import 'lottie_file.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key, required this.function});
  Function function;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> key = GlobalKey();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController(),
      auth = FirebaseAuth.instance,
      store = FirebaseFirestore.instance,
      focusE = FocusNode(),
      focusP = FocusNode(),
      focusN = FocusNode(),
      loading = false;

  signInGoogle() async {
    try {
      setState(() {
        loading = true;
      });
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          loading = false;
        });
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);

      await store.collection('users').doc(auth.currentUser!.uid).set({
        'name': googleSignInAccount.displayName,
        'points': 0,
        'plants': 0,
        'email': googleSignInAccount.email,
        'uid': auth.currentUser!.uid,
        'image': googleSignInAccount.photoUrl
      });

      Get.off(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  authentication() async {
    if (!key.currentState!.validate()) {
      return;
    }
    focusE.unfocus();
    focusN.unfocus();
    focusP.unfocus();
    setState(() {
      loading = true;
    });
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      await store.collection('users').doc(auth.currentUser!.uid).set({
        'name': name.text,
        'points': 0,
        'plants': 0,
        'email': email.text,
        'uid': auth.currentUser!.uid,
        'image': ''
      });

      Get.off(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

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
                  'Join the group :)',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
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
                EditTextFiled(
                  focus: focusN,
                  hint: 'Name',
                  secure: false,
                  icon: Icons.person,
                  controller: name,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter your name';
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
                        title: 'Sign Up',
                        function: authentication,
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
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/g.png',
                          height: 24,
                        ),
                        label: const Text('Sign Up with google')),
                  ),
                TButton(
                    title: 'Already have account? Sign In',
                    function: widget.function),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
