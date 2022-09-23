import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

const bottomSheetBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  ),
);

const dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
);

const outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(20)),
  borderSide: BorderSide.none,
);


final pageDecoration = const PageDecoration().copyWith(
  bodyFlex: 2,
  imageFlex: 4,
  bodyAlignment: Alignment.topCenter,
  imageAlignment: Alignment.bottomCenter,
);