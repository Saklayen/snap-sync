import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppButtonStyle { filled, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.filled,
    this.icon,
  });

  static const double _height = 52;
  static const double _radius = 14;

  final String label;
  final VoidCallback onPressed;
  final AppButtonStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final text = Text(label, style: _labelStyle(context));
    final glyph = icon;

    return switch (style) {
      AppButtonStyle.filled => glyph == null
          ? FilledButton(onPressed: onPressed, style: _filledStyle(), child: text)
          : FilledButton.icon(
              onPressed: onPressed,
              style: _filledStyle(),
              icon: Icon(glyph, size: 20),
              label: text,
            ),
      AppButtonStyle.outlined => glyph == null
          ? OutlinedButton(onPressed: onPressed, style: _outlinedStyle(), child: text)
          : OutlinedButton.icon(
              onPressed: onPressed,
              style: _outlinedStyle(),
              icon: Icon(glyph, size: 20),
              label: text,
            ),
    };
  }

  TextStyle? _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
          color: style == AppButtonStyle.filled ? white : blue500,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
        );
  }

  ButtonStyle _filledStyle() {
    return FilledButton.styleFrom(
      backgroundColor: blue500,
      foregroundColor: white,
      minimumSize: const Size.fromHeight(_height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
    );
  }

  ButtonStyle _outlinedStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: blue500,
      side: const BorderSide(color: blue500),
      minimumSize: const Size.fromHeight(_height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
    );
  }
}
