// test/widget_test.dart
//
// Basic Widget Test — Attendance App
// ═══════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';

import 'package:attendance_app/app_widget.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const AttendanceApp());
    await tester.pumpAndSettle();

    // Verify that the login screen renders with the school name.
    expect(find.text('SMA Muhammadiyah\nKasihan'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
