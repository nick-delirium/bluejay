import 'package:bluejay/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App is not crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const Bluejay());

    // Verify that our counter starts at 0.
    expect(find.text('BlueJay'), findsOneWidget);
    expect(find.text('Seagull'), findsNothing);

    await tester.tap(find.byIcon(Icons.login));
    await tester.pump();

    // // Verify that our counter has incremented.
    expect(find.text('This link will open Reddit'), findsOneWidget);
  });
}
