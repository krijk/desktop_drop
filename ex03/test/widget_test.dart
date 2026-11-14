import 'package:flutter_test/flutter_test.dart';

import 'package:ex03/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that our app title is shown.
    expect(find.text('Audio Creator'), findsOneWidget);
  });
}
