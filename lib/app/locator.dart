import 'package:get_it/get_it.dart';

import '../core/data/database/app_database.dart';
import '../core/data/database/upload_queue_dao.dart';
import '../feature/camera/data/camera_data_source.dart';
import '../feature/camera/data/capture_storage.dart';

final locator = GetIt.instance;

void registerDependencies() {
  locator
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<UploadQueueDao>(() => UploadQueueDao(locator()))
    ..registerLazySingleton<CaptureStorage>(CaptureStorage.new)
    ..registerFactory<CameraDataSource>(() => CameraDataSource(locator()));
}
