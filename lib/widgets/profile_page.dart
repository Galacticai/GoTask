import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotask/controllers/login_controller.dart';
import 'package:gotask/values/predefined_padding.dart';

import 'components/common/common_appbar.dart';
import 'components/profile_widgets/help_and_faq.dart';
import 'components/profile_widgets/logout.dart';
import 'components/profile_widgets/settings.dart';
import 'components/profile_widgets/your_information.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(builder: (context) => const ProfilePage());

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const bigSpace = SizedBox(height: PredefinedPadding.yomama);

    final user = Get.find<LoginController>().session.value?.user;

    return Scaffold(
      appBar: const CommonAppBar(title: "Profile"),
      body: ListView(
        padding: const EdgeInsets.all(PredefinedPadding.medium),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: PredefinedPadding.medium,
              right: PredefinedPadding.medium,
              bottom: PredefinedPadding.large,
            ),
            child: Row(
              children: [
                Hero(
                  tag: "pfp",
                  child: Image.network(
                    "https://picsum.photos/48/48/?blur=100",
                    width: 48,
                    height: 48,
                    errorBuilder: (_, __, ___) {
                      return Icon(Icons.person_rounded, color: theme.colorScheme.primary, size: 48);
                    },
                  ),
                ),
                const SizedBox(width: PredefinedPadding.medium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? "Anonymous",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user != null)
                      Text(
                        user.createdAt.toString(),
                        style: theme.textTheme.titleMedium,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const YourInformation(),
          bigSpace,
          const Settings(),
          const HelpAndFaq(),
          const Logout(),
          bigSpace,
        ],
      ),
    );
  }
}
