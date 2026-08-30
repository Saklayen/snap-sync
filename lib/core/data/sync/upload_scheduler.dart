import 'package:workmanager/workmanager.dart';

const uploadTaskName = 'snapsync-upload-queue';

class UploadScheduler {
  Future<void> enqueue() async {
    await Workmanager().registerOneOffTask(
      uploadTaskName,
      uploadTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 30),
    );
  }
}
