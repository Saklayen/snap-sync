import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

enum CameraStatus { starting, ready, unavailable }

enum CameraRecovery { none, retry, openSettings }

class ZoomOption extends Equatable {
  const ZoomOption({
    required this.label,
    required this.level,
    required this.isSelected,
  });

  final String label;
  final double level;
  final bool isSelected;

  @override
  List<Object?> get props => [label, level, isSelected];
}

class LensOption extends Equatable {
  const LensOption({
    required this.label,
    required this.index,
    required this.isSelected,
  });

  final String label;
  final int index;
  final bool isSelected;

  @override
  List<Object?> get props => [label, index, isSelected];
}

class CameraState extends Equatable {
  const CameraState({
    this.status = CameraStatus.starting,
    this.controller,
    this.message = '',
    this.recovery = CameraRecovery.none,
    this.recoveryLabel = '',
    this.zoom = 1,
    this.minZoom = 1,
    this.maxZoom = 1,
    this.minZoomLabel = '',
    this.maxZoomLabel = '',
    this.zoomOptions = const [],
    this.lensOptions = const [],
    this.canFlip = false,
    this.focusPoint = Offset.zero,
    this.isFocusLocked = false,
    this.capturePaths = const [],
    this.isCapturing = false,
    this.captureBadgeLabel = '',
  });

  final CameraStatus status;
  final CameraController? controller;
  final String message;
  final CameraRecovery recovery;
  final String recoveryLabel;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final String minZoomLabel;
  final String maxZoomLabel;
  final List<ZoomOption> zoomOptions;
  final List<LensOption> lensOptions;
  final bool canFlip;
  final Offset focusPoint;
  final bool isFocusLocked;
  final List<String> capturePaths;
  final bool isCapturing;
  final String captureBadgeLabel;

  bool get isPreviewVisible => status == CameraStatus.ready && controller != null;

  bool get hasRecovery => recovery != CameraRecovery.none;

  bool get isZoomAdjustable => maxZoom > minZoom;

  bool get hasLensChoice => lensOptions.isNotEmpty;

  bool get hasCaptures => capturePaths.isNotEmpty;

  int get captureCount => capturePaths.length;

  String get latestCapturePath => capturePaths.isEmpty ? '' : capturePaths.last;

  CameraState copyWith({
    CameraStatus? status,
    CameraController? controller,
    String? message,
    CameraRecovery? recovery,
    String? recoveryLabel,
    double? zoom,
    double? minZoom,
    double? maxZoom,
    String? minZoomLabel,
    String? maxZoomLabel,
    List<ZoomOption>? zoomOptions,
    List<LensOption>? lensOptions,
    bool? canFlip,
    Offset? focusPoint,
    bool? isFocusLocked,
    List<String>? capturePaths,
    bool? isCapturing,
    String? captureBadgeLabel,
  }) {
    return CameraState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      message: message ?? this.message,
      recovery: recovery ?? this.recovery,
      recoveryLabel: recoveryLabel ?? this.recoveryLabel,
      zoom: zoom ?? this.zoom,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      minZoomLabel: minZoomLabel ?? this.minZoomLabel,
      maxZoomLabel: maxZoomLabel ?? this.maxZoomLabel,
      zoomOptions: zoomOptions ?? this.zoomOptions,
      lensOptions: lensOptions ?? this.lensOptions,
      canFlip: canFlip ?? this.canFlip,
      focusPoint: focusPoint ?? this.focusPoint,
      isFocusLocked: isFocusLocked ?? this.isFocusLocked,
      capturePaths: capturePaths ?? this.capturePaths,
      isCapturing: isCapturing ?? this.isCapturing,
      captureBadgeLabel: captureBadgeLabel ?? this.captureBadgeLabel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        controller,
        message,
        recovery,
        recoveryLabel,
        zoom,
        minZoom,
        maxZoom,
        minZoomLabel,
        maxZoomLabel,
        zoomOptions,
        lensOptions,
        canFlip,
        focusPoint,
        isFocusLocked,
        capturePaths,
        isCapturing,
        captureBadgeLabel,
      ];
}
