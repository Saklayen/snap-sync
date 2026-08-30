import 'package:get_it/get_it.dart';

import '../core/data/database/app_database.dart';
import '../core/data/database/upload_queue_dao.dart';
import '../core/data/network/mock_upload_client.dart';
import '../core/data/network/upload_client.dart';
import '../core/data/sync/connectivity_observer.dart';
import '../core/data/sync/upload_scheduler.dart';
import '../feature/upload/data/upload_runner.dart';
import '../feature/camera/data/camera_data_source.dart';
import '../feature/camera/data/capture_storage.dart';

final locator = GetIt.instance;

void registerDependencies() {
  locator
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<UploadQueueDao>(() => UploadQueueDao(locator()))
    ..registerLazySingleton<CaptureStorage>(CaptureStorage.new)
    ..registerFactory<CameraDataSource>(() => CameraDataSource(locator()))
    ..registerLazySingleton<UploadClient>(MockUploadClient.new)
    ..registerLazySingleton<UploadRunner>(
      () => UploadRunner(locator(), locator(), locator()),
    )
    ..registerLazySingleton<ConnectivityObserver>(ConnectivityObserver.new)
    ..registerLazySingleton<UploadScheduler>(UploadScheduler.new);
}
