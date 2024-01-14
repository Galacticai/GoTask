import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gotask/controllers/login_controller.dart';
import 'package:gotask/values/predefined_radius.dart';

import 'profile_item.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProfileItem(
      icon: FontAwesomeIcons.rightFromBracket,
      header: Text(
        "Logout",
        style: ProfileItem.defaultHeaderStyle(theme),
      ),
      body: Row(
        children: [
          Icon(FontAwesomeIcons.solidFaceSadTear, color: theme.colorScheme.onSurface),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PredefinedRadius.medium,
              ),
              child: Text(
                "Are you sure?",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: LoginController.logout,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onError,
              backgroundColor: theme.colorScheme.error,
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PredefinedRadius.medium),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: PredefinedRadius.regular,
                horizontal: PredefinedRadius.medium,
              ),
            ),
            child: const Text("CONFIRM"),
          ),
        ],
      ),
    );
  }
}
