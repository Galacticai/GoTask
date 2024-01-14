import 'dart:math';

import 'package:flutter/material.dart';

extension ToUint8 on int {
  int toUint8() => max(0, min(0xFF, this));
}

extension ColorExtension on Color {
  HSLColor get hsl => HSLColor.fromColor(this);

  Color withHue(double brightness) => hsl.withHue(brightness).toColor();

  Color withSaturation(double brightness) => hsl.withSaturation(brightness).toColor();

  Color withBrightness(double brightness) => hsl.withLightness(brightness).toColor();

  Color withLightness(double brightness) => hsl.withLightness(brightness).toColor();

  /// Multiply the [red],[green],[blue] values with [brightness]
  /// - Note: this does not contain any crazy color theory math. It just simply multiplies the RGB values.
  Color multiply(double brightness) {
    final redNew = (red * brightness).toInt().toUint8();
    final greenNew = (green * brightness).toInt().toUint8();
    final blueNew = (blue * brightness).toInt().toUint8();
    return Color.fromARGB(alpha, redNew, greenNew, blueNew);
  }
}
