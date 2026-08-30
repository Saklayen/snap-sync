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
    this.focusPoint = Offset.zero,
    this.isFocusLocked = false,
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
  final Offset focusPoint;
  final bool isFocusLocked;

  bool get isPreviewVisible => status == CameraStatus.ready && controller != null;

  bool get hasRecovery => recovery != CameraRecovery.none;

  bool get isZoomAdjustable => maxZoom > minZoom;

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
    Offset? focusPoint,
    bool? isFocusLocked,
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
      focusPoint: focusPoint ?? this.focusPoint,
      isFocusLocked: isFocusLocked ?? this.isFocusLocked,
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
        focusPoint,
        isFocusLocked,
      ];
}
