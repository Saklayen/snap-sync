import 'package:flutter/material.dart';

import 'app/locator.dart';
import 'app/snap_sync_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerDependencies();
  runApp(const SnapSyncApp());
}
