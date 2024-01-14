import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_animation_duration.dart';
import 'package:gotask/values/predefined_padding.dart';

import 'add_button.dart';

class QuickAddBox extends StatefulWidget {
  const QuickAddBox({
    this.spacing = PredefinedPadding.big,
    super.key,
  });

  final double spacing;

  @override
  State<QuickAddBox> createState() => _QuickAddBoxState();
}

class _QuickAddBoxState extends State<QuickAddBox> {
  bool expanded = false;
  String text = "";

  late FocusNode textFieldFocus;

  @override
  void initState() {
    super.initState();

    textFieldFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedCrossFade(
              duration: PredefinedAnimationDuration.regular,
              secondCurve: Curves.easeOut,
              crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: TextField(
                focusNode: textFieldFocus,
                decoration: const InputDecoration(labelText: "Quick add"),
                onChanged: (value) => setState(() => text = value),
              ),
            ),
          ),
          SizedBox(width: widget.spacing),
          AddButton(
            onTap: (bool active) {
              setState(() {
                expanded = active;
                if (active) textFieldFocus.requestFocus();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textFieldFocus.dispose();

    super.dispose();
  }
}
