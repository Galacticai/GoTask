import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_padding.dart';
import 'package:gotask/values/predefined_style.dart';

Widget loginRegisterTitle(String text, {required ThemeData theme}) {
  return Flexible(
    child: Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(
        top: PredefinedPadding.largeXX,
        bottom: PredefinedPadding.largeXX,
        left: PredefinedPadding.medium,
        right: PredefinedPadding.medium,
      ),
      child: Text("Login", style: PredefinedStyle.pageTitle(theme)),
    ),
  );
}
