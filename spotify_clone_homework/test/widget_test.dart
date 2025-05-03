import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spotify_clone_homework/main.dart';

void main() {
  testWidgets('Spotify clone loads and displays key widgets', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(SpotifyCloneApp());

    // Check for the app bar title
    expect(find.text('Good Evening'), findsOneWidget);

    // Check for the "Now Playing" section
    expect(find.textContaining('Now Playing'), findsOneWidget);

    // Check that the bottom navigation bar items exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
  });
}
