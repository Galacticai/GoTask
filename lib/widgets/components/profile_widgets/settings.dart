import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'profile_item.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProfileItem(
      color: theme.colorScheme.onSurface,
      // headerBackgroundColor: theme.colorScheme.sur,
      icon: FontAwesomeIcons.gear,
      header: Text("Settings", style: ProfileItem.defaultHeaderStyle(theme)),
      body: Column(),
    );
  }
}
