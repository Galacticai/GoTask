import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gotask/common/widgets/map_list.dart';
import 'package:gotask/controllers/login_controller.dart';

import 'profile_item.dart';

class YourInformation extends StatelessWidget {
  const YourInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user = Get.find<LoginController>().session.value?.user;

    final Map<String, String> map = user == null
        ? {"User": "Not logged in"}
        : {
            "Email": user.email ?? "Anonymous",
            "ID": user.id,
            "Name": user.userMetadata?["full_name"] ?? "(Not set)",
            "Avatar": user.userMetadata?["avatar_url"] ?? "(Not set)",
            "Created at": user.createdAt.toString(),
            "Phone": user.phone == null || user.phone!.isEmpty ? "(Not set)" : user.phone!,
          };
    return ProfileItem(
      color: theme.colorScheme.primary,
      icon: FontAwesomeIcons.solidUser,
      header: Text("Your information", style: ProfileItem.defaultHeaderStylePrimary(theme)),
      body: MapList(
        map: map,
        keyStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
        valueStyle: theme.textTheme.bodyLarge,
      ),
    );
  }
}
