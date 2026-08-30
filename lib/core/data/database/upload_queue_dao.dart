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

  Stream<List<UploadItem>> watchCurrentBatch() {
    return _database
        .customSelect(
          'SELECT * FROM upload_items '
          'WHERE batch_id = (SELECT current_batch_id FROM queue_settings WHERE id = $_settingsId) '
          'ORDER BY id',
          readsFrom: {_database.uploadItems, _database.queueSettings},
        )
        .watch()
        .map((rows) => rows.map((row) => _database.uploadItems.map(row.data)).toList());
  }
}
