import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment/widgets/messagepage.dart';

void main() {
  testWidgets('ChatScreen Widget Test', (WidgetTester tester) async {
    // Build the ChatScreen widget
    await tester.pumpWidget(MaterialApp(
      home: ChatScreen(subtaskKey: 'subtaskKey'),
    ));

    // Verify the initial state of the ChatScreen
    expect(find.text('send'), findsOneWidget);
    expect(find.byType(MessagesStream), findsOneWidget);

    // Enter text in the TextField and tap the send button
    await tester.enterText(find.byType(TextField), 'Hello, World!');
    await tester.tap(find.text('send'));

    // Wait for the UI to update
    await tester.pump();

    // Verify that the text was cleared from the TextField
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '');

    // Verify that the message bubble is displayed
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}
