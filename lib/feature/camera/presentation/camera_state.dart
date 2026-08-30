import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

enum CameraStatus { starting, ready, unavailable }

enum CameraRecovery { none, retry, openSettings }

class CameraState extends Equatable {
  const CameraState({
    this.status = CameraStatus.starting,
    this.controller,
    this.message = '',
    this.recovery = CameraRecovery.none,
    this.recoveryLabel = '',
  });

  final CameraStatus status;
  final CameraController? controller;
  final String message;
  final CameraRecovery recovery;
  final String recoveryLabel;

  bool get isPreviewVisible => status == CameraStatus.ready && controller != null;

  bool get hasRecovery => recovery != CameraRecovery.none;

  CameraState copyWith({
    CameraStatus? status,
    CameraController? controller,
    String? message,
    CameraRecovery? recovery,
    String? recoveryLabel,
  }) {
    return CameraState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      message: message ?? this.message,
      recovery: recovery ?? this.recovery,
      recoveryLabel: recoveryLabel ?? this.recoveryLabel,
    );
  }

  @override
  List<Object?> get props => [status, controller, message, recovery, recoveryLabel];
}
