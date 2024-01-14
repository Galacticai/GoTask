import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_animation_duration.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key, required this.onTap});

  final Function(bool active) onTap;

  /// 135 degrees in the 0-1 range = 0.375
  static const double iconRotation = .375;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() => active = !active);
        widget.onTap(active);
      },
      child: AnimatedRotation(
        curve: Curves.easeOut,
        duration: PredefinedAnimationDuration.regular,
        turns: active ? AddButton.iconRotation : 0,
        child: const Icon(Icons.add_rounded, size: 36),
      ),
    );
  }
}
