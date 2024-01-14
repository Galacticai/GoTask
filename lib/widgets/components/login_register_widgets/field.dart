import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_radius.dart';

class LoginRegisterField extends StatefulWidget {
  const LoginRegisterField({
    required this.title,
    this.initialText,
    this.icon,
    this.enabled = true,
    this.error,
    this.isPassword = false,
    this.onChanged,
    super.key,
  });

  final String title;
  final String? initialText;
  final IconData? icon;
  final bool enabled;
  final String? error;
  final bool isPassword;
  final void Function(String value)? onChanged;

  @override
  State<LoginRegisterField> createState() => _LoginRegisterFieldState();
}

class _LoginRegisterFieldState extends State<LoginRegisterField> {
  bool get isError => widget.error != null;

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      initialValue: widget.initialText,
      focusNode: focusNode,
      enabled: widget.enabled,
      obscureText: widget.isPassword,
      obscuringCharacter: '⬤',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isError
            ? theme.colorScheme.error
            : focusNode.hasFocus //
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: widget.title,
        error: isError && widget.error!.isNotEmpty
            ? Text(
                widget.error!,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
              )
            : null,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PredefinedRadius.medium),
          borderSide: BorderSide(
            color: isError ? theme.colorScheme.error : theme.colorScheme.surfaceVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PredefinedRadius.medium),
          borderSide: BorderSide(
            color: isError ? theme.colorScheme.error : theme.colorScheme.primary,
          ),
        ),
        fillColor: theme.colorScheme.surface,
        prefixIcon: widget.icon == null ? null : Icon(widget.icon),
      ),
      onChanged: widget.onChanged?.call,
    );
  }
}
