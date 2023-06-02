import 'dart:convert';
import 'package:bluejay/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluejay/screens/feed/feed_view.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Provide a mock response
    return http.StreamedResponse(
      Stream.value(utf8.encode('Test Error')),
      500,
      headers: {},
    );
  }
}

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

  testWidgets('Initial View Index', (WidgetTester tester) async {
    await tester.pumpWidget(const Bluejay());

    // Verify that the initial view index is set correctly
    expect(find.byType(RedditFeedWidget), findsOneWidget);
  });
}
