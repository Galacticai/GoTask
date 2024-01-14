import 'package:flutter/material.dart';
import 'package:gotask/values/predefined_size.dart';
import 'package:gotask/values/predefined_style.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({required this.title, this.actions, super.key});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      backgroundColor: theme.colorScheme.background,
      systemOverlayStyle: PredefinedStyle.systemUiOverlay(theme),
      title: Text(
        title,
        style: PredefinedStyle.pageTitle(theme),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size(PredefinedSize.toolbarHeight * 4, PredefinedSize.toolbarHeight);
}
