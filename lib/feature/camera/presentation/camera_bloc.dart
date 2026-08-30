import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/app_error.dart';
import '../../../core/domain/result.dart';
import '../../../core/ui/effect_emitter.dart';
import '../../../core/ui/error_to_text.dart';
import '../data/camera_data_source.dart';
import 'camera_effect.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> with EffectEmitter<CameraEffect> {
  CameraBloc(this._dataSource) : super(const CameraState()) {
    on<CameraStarted>(_onStarted);
    on<CameraResumed>(_onResumed);
    on<CameraStopped>(_onStopped);
    on<CameraRecoveryRequested>(_onRecoveryRequested);
  }

  final CameraDataSource _dataSource;

  Future<void> _onStarted(CameraStarted event, Emitter<CameraState> emit) async {
    emit(const CameraState(status: CameraStatus.starting));

    final result = await _dataSource.start();

    emit(switch (result) {
      Success(:final data) => const CameraState(status: CameraStatus.ready).copyWith(
          controller: data,
        ),
      Failure(:final error) => CameraState(
          status: CameraStatus.unavailable,
          message: messageFor(error),
          recovery: _recoveryFor(error),
          recoveryLabel: _recoveryLabelFor(error),
        ),
    });
  }

  Future<void> _onResumed(CameraResumed event, Emitter<CameraState> emit) async {
    final result = await _dataSource.start(requestPermission: false);

    emit(switch (result) {
      Success(:final data) => const CameraState(status: CameraStatus.ready).copyWith(
          controller: data,
        ),
      Failure(:final error) => CameraState(
          status: CameraStatus.unavailable,
          message: messageFor(error),
          recovery: _recoveryFor(error),
          recoveryLabel: _recoveryLabelFor(error),
        ),
    });
  }

  Future<void> _onStopped(CameraStopped event, Emitter<CameraState> emit) async {
    await _dataSource.stop();
    emit(const CameraState());
  }

  Future<void> _onRecoveryRequested(
    CameraRecoveryRequested event,
    Emitter<CameraState> emit,
  ) async {
    if (state.recovery == CameraRecovery.openSettings) {
      emitEffect(const OpenAppSettingsEffect());
      return;
    }
    add(const CameraStarted());
  }

  @override
  Future<void> close() async {
    await _dataSource.stop();
    await closeEffects();
    return super.close();
  }
}

CameraRecovery _recoveryFor(AppError error) => switch (error) {
      CameraError.permissionDenied => CameraRecovery.retry,
      CameraError.permissionPermanentlyDenied => CameraRecovery.openSettings,
      CameraError.hardwareFailure => CameraRecovery.retry,
      CameraError.noCameraAvailable => CameraRecovery.none,
      _ => CameraRecovery.none,
    };

String _recoveryLabelFor(AppError error) => switch (error) {
      CameraError.permissionDenied => 'Allow camera access',
      CameraError.permissionPermanentlyDenied => 'Open Settings',
      CameraError.hardwareFailure => 'Try again',
      _ => '',
    };
