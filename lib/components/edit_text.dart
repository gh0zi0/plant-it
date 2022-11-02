import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditTextFiled extends StatefulWidget {
  EditTextFiled(
      {super.key,
      required this.icon,
      required this.secure,
      required this.controller,
      required this.validator,
      required this.hint});
  IconData icon;
  TextEditingController controller;
  String? Function(String?)? validator;
  String hint;
  bool secure;

  @override
  State<EditTextFiled> createState() => _EditTextFiledState();
}

class _EditTextFiledState extends State<EditTextFiled> {
  bool showPass = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: TextFormField(
        autocorrect: false,
        validator: widget.validator,
        controller: widget.controller,
        obscureText: widget.secure ? showPass : false,
        decoration: InputDecoration(
            suffixIcon: widget.secure
                ? IconButton(
                    onPressed: (() {
                      setState(() {
                        showPass = !showPass;
                      });
                    }),
                    icon: Icon(
                      !showPass ? Icons.visibility : Icons.visibility_off,
                    ))
                : null,
            hintText: widget.hint,
            prefixIcon: Icon(
              widget.icon,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
    );
  }
}
