import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/app_error.dart';
import '../../../core/domain/result.dart';
import '../../../core/ui/effect_emitter.dart';
import '../../../core/ui/error_to_text.dart';
import '../../../core/data/database/upload_queue_dao.dart';
import '../../../core/data/sync/upload_scheduler.dart';
import '../data/camera_data_source.dart';
import '../data/camera_session.dart';
import 'camera_effect.dart';
import 'camera_event.dart';
import 'camera_state.dart';

const _zoomStops = [0.5, 1.0, 2.0, 5.0];

class CameraBloc extends Bloc<CameraEvent, CameraState> with EffectEmitter<CameraEffect> {
  CameraBloc(this._dataSource, this._queue, this._scheduler)
      : super(const CameraState()) {
    on<CameraStarted>(_onStarted);
    on<CameraResumed>(_onResumed);
    on<CameraStopped>(_onStopped);
    on<CameraRecoveryRequested>(_onRecoveryRequested);
    on<CameraZoomChanged>(_onZoomChanged);
    on<CameraFocusRequested>(_onFocusRequested);
    on<CameraFocusReleased>(_onFocusReleased);
    on<CameraCaptureRequested>(_onCaptureRequested);
    on<CameraBatchChanged>(_onBatchChanged);
    on<CameraLensSelected>(_onLensSelected);
    on<CameraFlipped>(_onFlipped);
    on<CameraBatchSubmitted>(_onBatchSubmitted);

    _batchSubscription = _queue.watchCurrentBatch().listen(
          (items) => add(CameraBatchChanged([for (final item in items) item.filePath])),
        );
  }

  final CameraDataSource _dataSource;
  final UploadQueueDao _queue;
  final UploadScheduler _scheduler;
  late final StreamSubscription<void> _batchSubscription;

  Future<void> _onStarted(CameraStarted event, Emitter<CameraState> emit) async {
    emit(_keepBatch(const CameraState(status: CameraStatus.starting)));
    emit(_keepBatch(_stateFor(await _dataSource.start())));
  }

  Future<void> _onResumed(CameraResumed event, Emitter<CameraState> emit) async {
    emit(_keepBatch(_stateFor(await _dataSource.start(requestPermission: false))));
  }

  Future<void> _onStopped(CameraStopped event, Emitter<CameraState> emit) async {
    await _dataSource.stop();
    emit(_keepBatch(const CameraState()));
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

  Future<void> _onZoomChanged(CameraZoomChanged event, Emitter<CameraState> emit) async {
    final level = event.level.clamp(state.minZoom, state.maxZoom);

    emit(state.copyWith(
      zoom: level,
      zoomOptions: _zoomOptionsFor(level, state.minZoom, state.maxZoom),
    ));

    await _dataSource.setZoom(level);
  }

  Future<void> _onFocusRequested(
    CameraFocusRequested event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(focusPoint: event.point, isFocusLocked: true));

    await _dataSource.focusAt(event.point);
  }

  Future<void> _onFocusReleased(
    CameraFocusReleased event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(isFocusLocked: false));

    await _dataSource.releaseFocus();
  }

  Future<void> _onCaptureRequested(
    CameraCaptureRequested event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(isCapturing: true));

    final result = await _dataSource.capture();

    switch (result) {
      case Success(:final data):
        await _queue.enqueue(data);
        emit(state.copyWith(isCapturing: false));
      case Failure(:final error):
        emit(state.copyWith(isCapturing: false));
        emitEffect(ShowMessageEffect(messageFor(error)));
    }
  }

  Future<void> _onLensSelected(
    CameraLensSelected event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(status: CameraStatus.starting));
    emit(_keepBatch(_stateFor(await _dataSource.selectLens(event.index))));
  }

  Future<void> _onFlipped(CameraFlipped event, Emitter<CameraState> emit) async {
    emit(state.copyWith(status: CameraStatus.starting));
    emit(_keepBatch(_stateFor(await _dataSource.flipLens())));
  }

  void _onBatchChanged(CameraBatchChanged event, Emitter<CameraState> emit) {
    emit(state.copyWith(
      capturePaths: event.paths,
      captureBadgeLabel: _captureBadgeLabelFor(event.paths.length),
      uploadLabel: _uploadLabelFor(event.paths.length),
    ));
  }

  Future<void> _onBatchSubmitted(
    CameraBatchSubmitted event,
    Emitter<CameraState> emit,
  ) async {
    await _queue.closeCurrentBatch();
    await _scheduler.enqueue();
    emitEffect(const OpenUploadManagerEffect());
  }

  CameraState _keepBatch(CameraState next) => next.copyWith(
        capturePaths: state.capturePaths,
        captureBadgeLabel: state.captureBadgeLabel,
        uploadLabel: state.uploadLabel,
      );

  CameraState _stateFor(Result<CameraSession> result) => switch (result) {
        Success(:final data) => _readyState(data),
        Failure(:final error) => CameraState(
            status: CameraStatus.unavailable,
            message: messageFor(error),
            recovery: _recoveryFor(error),
            recoveryLabel: _recoveryLabelFor(error),
          ),
      };

  CameraState _readyState(CameraSession session) {
    final zoom = 1.0.clamp(session.minZoom, session.maxZoom);

    return CameraState(
      status: CameraStatus.ready,
      controller: session.controller,
      zoom: zoom,
      minZoom: session.minZoom,
      maxZoom: session.maxZoom,
      lensOptions: _lensOptionsFor(
        session.lensCount,
        session.activeLensIndex,
        session.isFrontLens,
      ),
      canFlip: session.canFlip,
      minZoomLabel: _stopLabelFor(session.minZoom),
      maxZoomLabel: _stopLabelFor(session.maxZoom),
      zoomOptions: _zoomOptionsFor(zoom, session.minZoom, session.maxZoom),
    );
  }

  @override
  Future<void> close() async {
    await _batchSubscription.cancel();
    await _dataSource.stop();
    await closeEffects();
    return super.close();
  }
}

List<ZoomOption> _zoomOptionsFor(double zoom, double minZoom, double maxZoom) {
  final stops = _zoomStops.where((s) => s >= minZoom && s <= maxZoom).toList();
  if (stops.length < 2) return const [];

  final selected = stops.lastWhere((s) => s <= zoom, orElse: () => stops.first);

  return [
    for (final stop in stops)
      ZoomOption(
        label: _stopLabelFor(stop),
        level: stop,
        isSelected: stop == selected,
      ),
  ];
}

String _captureBadgeLabelFor(int count) => '$count';

String _uploadLabelFor(int count) => 'UPLOAD BATCH ($count)';

List<LensOption> _lensOptionsFor(int lensCount, int activeIndex, bool isFrontLens) {
  if (isFrontLens || lensCount < 2) return const [];

  return [
    for (var index = 0; index < lensCount; index++)
      LensOption(
        label: 'LENS ${index + 1}',
        index: index,
        isSelected: index == activeIndex,
      ),
  ];
}

String _stopLabelFor(double stop) => stop == stop.roundToDouble()
    ? '${stop.toInt()}x'
    : '${stop.toStringAsFixed(1)}x';

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
