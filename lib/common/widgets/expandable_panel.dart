import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gotask/values/predefined_padding.dart';

import 'animated_tap.dart';

@immutable
class ExpandablePanel extends StatefulWidget {
  const ExpandablePanel({
    super.key,
    required this.header,
    required this.body,
    this.icon,
    this.iconSize,
    this.initiallyExpanded = false,
    this.showArrow = true,
    this.customArrow,
    this.useInkWell = false,
    this.color,
    this.headerBackgroundColor,
    this.bodyBackgroundColor,
    this.headerPadding,
    this.bodyPadding,
    this.borderRadius,
  });

  final Widget header;
  final Widget body;
  final IconData? icon;
  final double? iconSize;
  final bool initiallyExpanded;
  final bool showArrow;
  final Widget? customArrow;
  final bool useInkWell;
  final Color? color;
  final Color? headerBackgroundColor;
  final Color? bodyBackgroundColor;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? bodyPadding;
  final double? borderRadius;

  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  late bool _isExpanded;

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    final borderRadius = BorderRadius.circular(widget.borderRadius ?? 0);
    final border = widget.borderRadius == null ? null : RoundedRectangleBorder(borderRadius: borderRadius);

    const duration = Duration(milliseconds: 200);
    final iconPadding = widget.headerPadding == null
        ? const SizedBox.shrink()
        : SizedBox(width: widget.headerPadding!.horizontal / 4);

    List<Widget> leading = [const SizedBox.shrink()];
    List<Widget> trailing = [const SizedBox.shrink()];
    if (widget.icon != null) {
      leading = [
        iconPadding,
        Icon(
          widget.icon,
          size: widget.iconSize,
          color: widget.color,
        ),
        iconPadding,
        iconPadding,
      ];
    }

    if (widget.showArrow) {
      if (widget.customArrow != null) {
        trailing = [widget.customArrow!];
      } else {
        final icon = Icon(FontAwesomeIcons.chevronDown, color: widget.color);
        final iconContainer = AnimatedScale(
          scale: _isExpanded ? -1 : 1,
          duration: duration,
          curve: Curves.easeOut,
          child: widget.useInkWell
              ? Padding(
                  padding: const EdgeInsets.all(PredefinedPadding.regular),
                  child: icon,
                )
              : IconButton(
                  icon: icon,
                  onPressed: _toggle,
                  color: widget.color,
                ),
        );
        trailing = [
          iconPadding,
          iconPadding,
          iconContainer,
          iconPadding,
        ];
      }
    }

    return AnimatedTap(
      useInkWell: widget.useInkWell,
      inkWellColor: widget.color,
      inkWellBorderRadius: borderRadius,
      tapDownOpacity: .5,
      onTap: _toggle,
      child: Card(
        shape: border,
        color: widget.bodyBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: widget.headerPadding,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: widget.headerBackgroundColor,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...leading,
                  Expanded(child: widget.header),
                  ...trailing,
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: duration,
              sizeCurve: Curves.easeInOut,
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Container(),
              secondChild: Container(
                padding: widget.bodyPadding,
                child: widget.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
