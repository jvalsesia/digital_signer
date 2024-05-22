import 'package:flutter/material.dart';

const kBottomContainerHeight = 80.0;

// 0xFF272727
// 0xFF000000
// 0xFFC3FE75
// 0xFF8D8D90
const Color kAppBackgroundColor = Color(0xFF000000);
const Color kActiveCardColor = Color(0x29C3FE75);
const Color kInactiveCardColor = Color(0xFF111328);
const Color kButtonContainerColor = Color.fromARGB(255, 26, 29, 65);
const Color kBottomContainerColor = Color(0xFFC3FE75);
const Color kOverlayColor = Color(0x29C3FE75);
const Color kForegroundContainerColor = Color(0xFFFFFFFF);
const Color kLabelColor = Color(0xFF8D8E98);
const Color kResultGreenColor = Color(0xFF24D876);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: kLabelColor,
);

const kLabelTextStyleOk = TextStyle(
  fontSize: 18.0,
  color: Colors.green,
);

const kLabelTextStyleNotOk = TextStyle(
  fontSize: 18.0,
  color: Colors.red,
);

const kSliderTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
  color: kForegroundContainerColor,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: kLabelColor,
);

const kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  color: kForegroundContainerColor,
);

const kResultTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: kResultGreenColor,
);

const kBmiTextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
  color: kForegroundContainerColor,
);

const kBodyResultTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w300,
  color: kForegroundContainerColor,
);
