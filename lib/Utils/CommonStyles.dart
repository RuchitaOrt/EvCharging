

import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';

class CommonStyles {
  CommonStyles._privateConstructor();
   static const TextStyle tsblackHeading = TextStyle(
    color: CommonColors.blackshade,
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );
      static const TextStyle textFieldHeading = TextStyle(
    color: CommonColors.mapDark,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
  );
   static const TextStyle textFieldHint = TextStyle(
    color: CommonColors.hintGrey,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
  );
}
