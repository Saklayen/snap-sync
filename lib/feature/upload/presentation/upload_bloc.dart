import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/database/app_database.dart';
import '../../../core/data/database/upload_queue_dao.dart';
import '../../../core/data/sync/connectivity_observer.dart';
import '../../../core/designsystem/theme/app_status_colors.dart';
import '../../../core/domain/upload_state.dart';
import '../../../core/ui/byte_format.dart';
import '../data/upload_runner.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadManagerBloc extends Bloc<UploadManagerEvent, UploadManagerState> {
  UploadManagerBloc(this._queue, this._runner, this._connectivity)
      : super(const UploadManagerState()) {
    on<UploadQueueChanged>(_onQueueChanged);
    on<UploadConnectivityChanged>(_onConnectivityChanged);

    _queueSubscription =
        _queue.watchSubmitted().listen((items) => add(UploadQueueChanged(items)));

    _connectivitySubscription = _connectivity
        .observe()
        .listen((isOnline) => add(UploadConnectivityChanged(isOnline)));
  }

  final UploadQueueDao _queue;
  final UploadRunner _runner;
  final ConnectivityObserver _connectivity;
  late final StreamSubscription<void> _connectivitySubscription;
  late final StreamSubscription<void> _queueSubscription;

  void _onQueueChanged(UploadQueueChanged event, Emitter<UploadManagerState> emit) {
    final items = event.items;
    final sent = items.fold<int>(0, (total, item) => total + item.bytesSent);
    final size = items.fold<int>(0, (total, item) => total + item.totalBytes);
    final progress = size == 0 ? 0.0 : sent / size;

    emit(state.copyWith(
      rows: _rowsFor(items),
      pendingLabel: 'PENDING UPLOADS (${items.length})',
      progress: progress,
      progressLabel: '${(progress * 100).round()}%',
      bytesLabel: '${formatBytes(sent)} / ${formatBytes(size)} Uploaded',
      isEmpty: items.isEmpty,
    ));
  }

  void _onConnectivityChanged(
    UploadConnectivityChanged event,
    Emitter<UploadManagerState> emit,
  ) {
    emit(state.copyWith(
      connectionLabel: event.isOnline ? 'STABLE LINK' : 'NO CONNECTION',
      connectionTone: event.isOnline ? UploadTone.synced : UploadTone.retrying,
    ));

    if (event.isOnline) unawaited(_runner.start());
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    await _queueSubscription.cancel();
    return super.close();
  }
}

List<UploadRowUi> _rowsFor(List<UploadItem> items) {
  var headTaken = false;

  return [
    for (final item in items)
      () {
        final isHead = item.state == UploadState.pending && !headTaken;
        if (isHead) headTaken = true;
        return _rowFor(item, isHead: isHead);
      }(),
  ];
}

UploadRowUi _rowFor(UploadItem item, {required bool isHead}) {
  final progress = item.totalBytes == 0 ? 0.0 : item.bytesSent / item.totalBytes;

  return switch (item.state) {
    UploadState.synced => _row(item, 'SYNCED', UploadTone.synced, progress),
    UploadState.uploading => _row(
        item,
        'UPLOADING — ${(progress * 100).round()}%',
        UploadTone.uploading,
        progress,
        isActive: true,
        hasProgressBar: true,
      ),
    UploadState.failed when item.attempts >= maxUploadAttempts =>
      _row(item, 'UPLOAD FAILED', UploadTone.retrying, progress),
    UploadState.failed => _row(
        item,
        'RETRYING… ATTEMPT ${item.attempts}/$maxUploadAttempts',
        UploadTone.retrying,
        progress,
      ),
    UploadState.pending when isHead =>
      _row(item, 'WAITING FOR CONNECTION', UploadTone.waiting, progress),
    UploadState.pending =>
      _row(item, 'IN QUEUE', UploadTone.queued, progress, isDimmed: true),
  };
}

UploadRowUi _row(
  UploadItem item,
  String statusLabel,
  UploadTone tone,
  double progress, {
  bool isActive = false,
  bool isDimmed = false,
  bool hasProgressBar = false,
}) {
  return UploadRowUi(
    id: item.id,
    filePath: item.filePath,
    fileName: item.filePath.split('/').last,
    sizeLabel: formatBytes(item.totalBytes),
    statusLabel: statusLabel,
    tone: tone,
    progress: progress,
    isActive: isActive,
    isDimmed: isDimmed,
    hasProgressBar: hasProgressBar,
  );
}
