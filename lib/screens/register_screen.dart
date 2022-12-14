import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plantit/components/sign_in.dart';
import 'package:plantit/components/sign_up.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import '../components/e_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var signIn = true, show = false;
  final SolidController _controller = SolidController();

  controlSheet() async {
    setState(() {
      show = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      signIn = !signIn;
      show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SingleChildScrollView(
        child: SolidBottomSheet(
          maxHeight: MediaQuery.of(context).size.height / 1.1,
          showOnAppear: show,
          controller: _controller,
          draggableBody: true,
          headerBar: Container(),
          body: signIn
              ? SignIn(
                  function: controlSheet,
                )
              : SignUp(
                  function: controlSheet,
                ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/rigester.png',
          ),
          Container(
            padding: const EdgeInsets.only(right: 50, left: 50),
            child: const Text(
              'magical',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ).tr(),
          ),
          Container(
            padding: const EdgeInsets.only(right: 50, left: 50),
            child: const Text(
              'things',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ).tr(),
          ),
          Container(
              padding: const EdgeInsets.only(
                  right: 50, left: 50, top: 5, bottom: 20),
              child: const Text('green').tr()),
          Container(
            alignment: Alignment.center,
            child: EButton(
              title: 'signIn',
              function: () {
                setState(() {
                  show = true;
                  signIn = true;
                });
              },
              h: 55,
              w: MediaQuery.of(context).size.width / 1.25,
              color: const Color(0xFF009345),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10, bottom: 40),
            child: EButton(
              title: 'signUp',
              function: () {
                setState(() {
                  show = true;
                  signIn = false;
                });
              },
              h: 55,
              w: MediaQuery.of(context).size.width / 1.25,
              color: Colors.white,
              tColor: const Color(0xFF009345),
            ),
          )
        ],
      ),
    );
  }
}
