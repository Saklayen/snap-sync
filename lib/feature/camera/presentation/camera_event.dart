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
