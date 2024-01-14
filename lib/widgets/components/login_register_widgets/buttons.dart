import 'package:flutter/material.dart';

Widget loginRegisterButton({
  required String text,
  IconData? icon,
  required VoidCallback onPressed,
  required bool isLoading,
}) {
  final style = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Colors.amber),
  );
  final action = isLoading ? null : onPressed;
  final label = Text(text);
  return icon == null
      ? TextButton(style: style, onPressed: action, child: label)
      : TextButton.icon(style: style, onPressed: action, label: label, icon: Icon(icon));
}
