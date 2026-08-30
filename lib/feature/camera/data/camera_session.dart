import 'package:camera/camera.dart';

class CameraSession {
  const CameraSession({
    required this.controller,
    required this.minZoom,
    required this.maxZoom,
    required this.lensCount,
    required this.activeLensIndex,
    required this.canFlip,
    required this.isFrontLens,
    required this.flashMode,
  });

  final CameraController controller;
  final double minZoom;
  final double maxZoom;
  final int lensCount;
  final int activeLensIndex;
  final bool canFlip;
  final bool isFrontLens;
  final FlashMode flashMode;
}
