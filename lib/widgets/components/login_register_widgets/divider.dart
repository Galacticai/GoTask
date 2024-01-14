import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_padding.dart';

class LoginRegisterDivider extends StatelessWidget {
  const LoginRegisterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PredefinedPadding.large),
      child: Divider(color: Theme.of(context).colorScheme.outline.withOpacity(.4)),
    );
  }
}
