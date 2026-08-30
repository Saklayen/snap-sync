import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'app/background.dart';
import 'app/locator.dart';
import 'app/snap_sync_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerDependencies();
  await Workmanager().initialize(callbackDispatcher);
  runApp(const SnapSyncApp());
}
