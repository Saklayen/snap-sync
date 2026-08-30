import 'dart:async';

import '../../../core/data/database/upload_queue_dao.dart';
import '../../../core/data/network/upload_client.dart';
import '../../../core/data/sync/connectivity_observer.dart';
import '../../../core/domain/result.dart';
import '../../../core/domain/upload_state.dart';
import '../../../core/ui/error_to_text.dart';

const _retryBackoff = Duration(milliseconds: 900);

class UploadRunner {
  UploadRunner(this._queue, this._client, this._connectivity);

  final UploadQueueDao _queue;
  final UploadClient _client;
  final ConnectivityObserver _connectivity;

  Future<void>? _running;

  Future<void> start() => _running ??= _drain().whenComplete(() => _running = null);

  Future<void> _drain() async {
    while (true) {
      if (!await _connectivity.isOnline()) return;

      final item = await _queue.nextEligible(maxAttempts: maxUploadAttempts);
      if (item == null) return;

      await _queue.markUploading(item.id);

      final result = await _client.upload(
        filePath: item.filePath,
        totalBytes: item.totalBytes,
        onProgress: (bytesSent) => _queue.updateProgress(item.id, bytesSent),
      );

      switch (result) {
        case Success():
          await _queue.markSynced(item.id, item.totalBytes);
        case Failure(:final error):
          await _queue.markFailed(item.id, item.attempts + 1, messageFor(error));
          await Future<void>.delayed(_retryBackoff);
      }
    }
  }
}
