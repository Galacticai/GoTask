import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_padding.dart';

class MapList extends StatelessWidget {
  const MapList({
    super.key,
    required this.map,
    this.keyStyle,
    this.valueStyle,
  });

  final Map<String, String> map;
  final TextStyle? keyStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (final entry in map.entries) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: PredefinedPadding.small));
      }
      children.add(
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '${entry.key}: ', style: keyStyle),
              TextSpan(text: entry.value, style: valueStyle),
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
