import 'package:camera/camera.dart';

class CameraSession {
  const CameraSession({
    required this.controller,
    required this.minZoom,
    required this.maxZoom,
  });

  final CameraController controller;
  final double minZoom;
  final double maxZoom;
}
