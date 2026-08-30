import 'dart:ui';

import 'package:workmanager/workmanager.dart';

import '../core/data/database/app_database.dart';
import '../core/data/database/upload_queue_dao.dart';
import '../core/data/network/mock_upload_client.dart';
import '../core/data/sync/connectivity_observer.dart';
import '../feature/upload/data/upload_runner.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    DartPluginRegistrant.ensureInitialized();

    final database = AppDatabase();

    try {
      await UploadRunner(
        UploadQueueDao(database),
        MockUploadClient(),
        ConnectivityObserver(),
      ).start();
    } finally {
      await database.close();
    }

    return true;
  });
}
