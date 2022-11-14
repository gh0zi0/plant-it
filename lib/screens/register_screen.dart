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
  var signIn = true, show = false, loading = false;
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
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/wall.png'),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              EButton(
                title: 'signIn',
                function: () {
                  setState(() {
                    show = true;
                    signIn = true;
                  });
                },
                h: 50,
                w: 150,
                color: Colors.green,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 50),
                child: EButton(
                  title: 'signUp',
                  function: () {
                    setState(() {
                      show = true;
                      signIn = false;
                    });
                  },
                  h: 50,
                  w: 150,
                  color: Colors.grey,
                ),
              )
            ],
          )),
    );
  }
}
