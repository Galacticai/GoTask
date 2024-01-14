import 'package:flutter/material.dart';

class AnimatedTap extends StatefulWidget {
  const AnimatedTap({
    this.child,
    this.useInkWell = true,
    this.inkWellBorderRadius,
    this.inkWellColor,
    this.tapDownScale = .95,
    this.tapDownOpacity = .6,
    this.opacityDuration = const Duration(milliseconds: 300),
    this.scaleDuration = const Duration(milliseconds: 150),
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    super.key,
  });

  final Widget? child;
  final bool useInkWell;
  final BorderRadius? inkWellBorderRadius;
  final Color? inkWellColor;
  final double tapDownScale;
  final double tapDownOpacity;
  final Duration opacityDuration;
  final Duration scaleDuration;
  final Function()? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final Function()? onTapCancel;

  @override
  State<AnimatedTap> createState() => _AnimatedTapCardState();
}

class _AnimatedTapCardState extends State<AnimatedTap> {
  bool tapping = false;
  bool animating = false;
  bool isDown = false;

  void _setTap(bool value) => setState(() => tapping = value);

  void _onTapDown(TapDownDetails tapDownDetails) {
    _setTap(true);
    widget.onTapDown?.call(tapDownDetails);
    animating = true;
    isDown = true;

    Future.delayed(
      widget.scaleDuration.compareTo(widget.opacityDuration) > 0
          ? widget.scaleDuration
          : widget.opacityDuration,
      () {
        if (animating && !isDown) {
          _setTap(false);
          animating = false;
        }
      },
    );
  }

  void _onTapUp(TapUpDetails tapUpDetails) {
    if (!animating) _setTap(false);
    isDown = false;
    widget.onTapUp?.call(tapUpDetails);
  }

  void _onTapCancel() {
    _setTap(false);
    widget.onTapCancel?.call();
  }

  void _onTap() {
    //? Need this to reset if the tapUp event was skipped (ex: in case of pop up)
    Future.delayed(widget.scaleDuration, () {
      _setTap(false);
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: tapping ? widget.tapDownOpacity : 1,
      duration: widget.opacityDuration,
      curve: Curves.decelerate,
      child: AnimatedScale(
        scale: tapping ? widget.tapDownScale : 1,
        duration: widget.scaleDuration,
        curve: Curves.decelerate,
        child: widget.useInkWell
            ? InkWell(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: _onTap,
                splashColor: widget.inkWellColor,
                highlightColor: widget.inkWellColor?.withOpacity(.25),
                borderRadius: widget.inkWellBorderRadius,
                child: widget.child,
              )
            : GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: _onTap,
                behavior: HitTestBehavior.translucent,
                child: widget.child,
              ),
      ),
    );
  }
}
