import 'package:flutter/material.dart';

class CustomButon extends StatelessWidget {
  CustomButon(
      {Key? key, this.onTap, required this.text, required this.btncolor})
      : super(key: key);
  VoidCallback? onTap;
  String text;
  Color btncolor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: btncolor,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
