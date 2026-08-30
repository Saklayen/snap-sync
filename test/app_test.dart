import 'package:flutter_test/flutter_test.dart';
import 'package:snapsync/app/snap_sync_app.dart';

void main() {
  testWidgets('the app renders its name', (tester) async {
    await tester.pumpWidget(const SnapSyncApp());

    expect(find.text('SnapSync'), findsOneWidget);
  });
}
