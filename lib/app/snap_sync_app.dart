import 'package:flutter/material.dart';

import '../core/designsystem/theme/app_theme.dart';
import '../feature/camera/presentation/camera_screen.dart';

class SnapSyncApp extends StatelessWidget {
  const SnapSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSync',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const CameraScreen(),
    );
  }
}
