import 'dart:io';

import 'package:drift/drift.dart';

import '../../domain/upload_state.dart';
import 'app_database.dart';

class UploadQueueDao {
  UploadQueueDao(this._database);

  static const _settingsId = 0;

  final AppDatabase _database;

  Future<int> currentBatchId() async {
    final settings = await (_database.select(_database.queueSettings)
          ..where((row) => row.id.equals(_settingsId)))
        .getSingle();

    return settings.currentBatchId;
  }

  Future<void> enqueue(String filePath) async {
    final batchId = await currentBatchId();
    final totalBytes = await File(filePath).length();

    await _database.into(_database.uploadItems).insert(
          UploadItemsCompanion.insert(
            batchId: batchId,
            filePath: filePath,
            state: UploadState.pending,
            createdAt: DateTime.now(),
            totalBytes: Value(totalBytes),
          ),
        );
  }

  Future<UploadItem?> nextEligible({required int maxAttempts}) async {
    final row = await _database.customSelect(
      'SELECT * FROM upload_items '
      'WHERE batch_id < (SELECT current_batch_id FROM queue_settings WHERE id = $_settingsId) '
      'AND state IN (?, ?) AND attempts < ? ORDER BY id LIMIT 1',
      variables: [
        Variable.withInt(UploadState.pending.index),
        Variable.withInt(UploadState.failed.index),
        Variable.withInt(maxAttempts),
      ],
      readsFrom: {_database.uploadItems, _database.queueSettings},
    ).getSingleOrNull();

    return row == null ? null : _database.uploadItems.map(row.data);
  }

  Future<void> markUploading(int id) => _write(
        id,
        const UploadItemsCompanion(
          state: Value(UploadState.uploading),
          bytesSent: Value(0),
        ),
      );

  Future<void> updateProgress(int id, int bytesSent) =>
      _write(id, UploadItemsCompanion(bytesSent: Value(bytesSent)));

  Future<void> markSynced(int id, int totalBytes) => _write(
        id,
        UploadItemsCompanion(
          state: const Value(UploadState.synced),
          bytesSent: Value(totalBytes),
          lastError: const Value(null),
        ),
      );

  Future<void> markFailed(int id, int attempts, String error) => _write(
        id,
        UploadItemsCompanion(
          state: const Value(UploadState.failed),
          attempts: Value(attempts),
          lastError: Value(error),
          bytesSent: const Value(0),
        ),
      );

  Future<void> _write(int id, UploadItemsCompanion values) async {
    await (_database.update(_database.uploadItems)
          ..where((row) => row.id.equals(id)))
        .write(values);
  }

  Future<void> closeCurrentBatch() async {
    await _database.transaction(() async {
      final batchId = await currentBatchId();
      final open = await (_database.select(_database.uploadItems)
            ..where((row) => row.batchId.equals(batchId)))
          .get();

      if (open.isEmpty) return;

      await (_database.update(_database.queueSettings)
            ..where((row) => row.id.equals(_settingsId)))
          .write(QueueSettingsCompanion(currentBatchId: Value(batchId + 1)));
    });
  }

  Stream<List<UploadItem>> watchSubmitted() {
    return _watch(
      'SELECT * FROM upload_items '
      'WHERE batch_id < (SELECT current_batch_id FROM queue_settings WHERE id = $_settingsId) '
      'ORDER BY batch_id DESC, id ASC',
    );
  }

  Stream<List<UploadItem>> watchCurrentBatch() {
    return _watch(
      'SELECT * FROM upload_items '
      'WHERE batch_id = (SELECT current_batch_id FROM queue_settings WHERE id = $_settingsId) '
      'ORDER BY id',
    );
  }

  Stream<List<UploadItem>> _watch(String query) {
    return _database
        .customSelect(
          query,
          readsFrom: {_database.uploadItems, _database.queueSettings},
        )
        .watch()
        .map((rows) => rows.map((row) => _database.uploadItems.map(row.data)).toList());
  }
}
