import 'package:flutter_test/flutter_test.dart';
import 'package:software_engineering_project_pc_konfiguration_app/app.dart';

void main() {
  testWidgets('App smoke test', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();
    expect(find.text('Willkommen bei BuildMyPC'), findsOneWidget);
  });
}