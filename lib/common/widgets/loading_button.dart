import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_animation_duration.dart';

Widget LoadingButton(
  String text, {
  required VoidCallback onPressed,
  required bool isLocked,
  required bool isLoading,
  double loadingWidth = 100,
}) {
  return ElevatedButton(
    onPressed: isLocked ? null : onPressed,
    child: AnimatedCrossFade(
      duration: PredefinedAnimationDuration.regular,
      crossFadeState: isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: Text(text),
      secondChild: SizedBox(width: loadingWidth, child: const LinearProgressIndicator()),
    ),
  );
}
