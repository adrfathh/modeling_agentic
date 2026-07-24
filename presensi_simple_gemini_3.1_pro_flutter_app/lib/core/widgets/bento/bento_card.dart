import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';

enum BentoSize { small, wide, tall, large }

class BentoCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BentoSize size;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const BentoCard({
    super.key,
    required this.child,
    this.onTap,
    this.size = BentoSize.small,
    this.padding,
    this.backgroundColor,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double radius = (widget.size == BentoSize.large || widget.size == BentoSize.tall)
        ? AppDimensions.radiusBentoLarge
        : AppDimensions.radiusBentoSmall;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColorTokens.surfaceElevated,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: _isPressed ? AppDimensions.shadowBento2 : AppDimensions.shadowBento1,
            border: Border.all(
              color: AppColorTokens.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: widget.padding ?? AppDimensions.cardPadding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
