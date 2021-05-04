import 'package:flutter/material.dart';

class AuthenticationInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool isObscure;
  const AuthenticationInput(
      {Key key,
      this.hintText = '',
      @required this.controller,
      @required this.icon,
      this.isObscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
      ),
    );
  }
}
