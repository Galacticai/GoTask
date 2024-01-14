import 'package:flutter/material.dart';

BoxDecoration LoginRegisterBackground(ColorScheme colorScheme) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0, .7, 1],
      colors: [
        colorScheme.primary.withOpacity(.2),
        colorScheme.surface.withOpacity(.9),
        colorScheme.background,
      ],
    ),
  );
}
