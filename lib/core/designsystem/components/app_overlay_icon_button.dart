import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppOverlayIconButton extends StatelessWidget {
  const AppOverlayIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: overlayStrong,
        ),
        child: Icon(icon, size: size * 0.48, color: white),
      ),
    );
  }
}
