import 'dart:ui';

import 'package:equatable/equatable.dart';

sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => const [];
}

final class CameraStarted extends CameraEvent {
  const CameraStarted();
}

final class CameraResumed extends CameraEvent {
  const CameraResumed();
}

final class CameraStopped extends CameraEvent {
  const CameraStopped();
}

final class CameraRecoveryRequested extends CameraEvent {
  const CameraRecoveryRequested();
}

final class CameraZoomChanged extends CameraEvent {
  const CameraZoomChanged(this.level);

  final double level;

  @override
  List<Object?> get props => [level];
}

final class CameraFocusRequested extends CameraEvent {
  const CameraFocusRequested(this.point);

  final Offset point;

  @override
  List<Object?> get props => [point];
}

final class CameraFocusReleased extends CameraEvent {
  const CameraFocusReleased();
}

final class CameraCaptureRequested extends CameraEvent {
  const CameraCaptureRequested();
}

final class CameraBatchChanged extends CameraEvent {
  const CameraBatchChanged(this.paths);

  final List<String> paths;

  @override
  List<Object?> get props => [paths];
}

final class CameraLensSelected extends CameraEvent {
  const CameraLensSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class CameraFlipped extends CameraEvent {
  const CameraFlipped();
}

final class CameraBatchSubmitted extends CameraEvent {
  const CameraBatchSubmitted();
}

final class CameraUploadManagerRequested extends CameraEvent {
  const CameraUploadManagerRequested();
}

final class CameraFlashToggled extends CameraEvent {
  const CameraFlashToggled();
}

final class CameraCloseRequested extends CameraEvent {
  const CameraCloseRequested();
}
