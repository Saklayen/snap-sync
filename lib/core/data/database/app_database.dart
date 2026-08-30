import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/upload_state.dart';

part 'app_database.g.dart';

class UploadItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get batchId => integer()();
  TextColumn get filePath => text()();
  IntColumn get state => intEnum<UploadState>()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get bytesSent => integer().withDefault(const Constant(0))();
  IntColumn get totalBytes => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

class QueueSettings extends Table {
  IntColumn get id => integer()();
  IntColumn get currentBatchId => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [UploadItems, QueueSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'snapsync'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await into(queueSettings).insert(
            const QueueSettingsCompanion(id: Value(0)),
            mode: InsertMode.insertOrIgnore,
          );
        },
      );
}
