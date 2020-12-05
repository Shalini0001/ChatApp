import 'package:animationApp/main.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      "Search Users",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    backgroundColor: Colors.blue[600],
  );
}

InputDecoration textFieldDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle whiteTextStyle() {
  return TextStyle(color: Colors.white);
}

TextStyle mediumWhiteTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}
