import 'package:flutter/material.dart';

const Color kYellow= Color(0xffffee00);

const TextStyle kHeadingStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
);


const TextStyle kSubHeadingStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);


const TextStyle kTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);


Map<int, Color> errorCodeColors = {
  0: Colors.green, //Ok
  1: Colors.yellow, //Warn
  2: Colors.red, //Error
  3: Colors.grey.shade300 //Stale
};

Color kDarkGrey = Color(0xff43474E);