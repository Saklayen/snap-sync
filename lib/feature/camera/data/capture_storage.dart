import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CaptureStorage {
  static const _folder = 'captures';

  Future<String> persist(String sourcePath) async {
    final documents = await getApplicationDocumentsDirectory();
    final captures = Directory('${documents.path}/$_folder');
    await captures.create(recursive: true);

    final target = '${captures.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
    await File(sourcePath).copy(target);
    await File(sourcePath).delete();

    return target;
  }
}
