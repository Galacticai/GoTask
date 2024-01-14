import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'profile_item.dart';

class HelpAndFaq extends StatelessWidget {
  const HelpAndFaq({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProfileItem(
      icon: FontAwesomeIcons.solidCircleQuestion,
      header: Text("Help & FAQ", style: ProfileItem.defaultHeaderStyle(theme)),
      body: Column(),
    );
  }
}
