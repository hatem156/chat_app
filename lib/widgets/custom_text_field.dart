import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({
    Key? key,
    this.hintText,
    required this.textrcolor,
    this.obscureText = false,
    required this.bordercolor,
    this.data,
  }) : super(key: key);

  String? hintText;
  Color bordercolor;
  Color textrcolor;
  bool? obscureText;
  var data;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        data = value;
      },
      obscureText: obscureText!,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: textrcolor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: bordercolor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: textrcolor,
          ),
        ),
      ),
    );
  }
}
