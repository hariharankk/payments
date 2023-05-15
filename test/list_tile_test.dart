import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('listtile widget test', (WidgetTester tester) async {
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: listtile(
          text: 'Title',
          subtitle: 'Subtitle',
          icon: Icon(Icons.ac_unit),
        ),
      ),
    ));

    
    expect(find.byType(ListTile), findsOneWidget);

    expect(find.text('Title'), findsOneWidget);

    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
  });
}

class listtile extends StatelessWidget {
  listtile({required this.subtitle, required this.text, required this.icon});

  final String text;
  final String subtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        textScaleFactor: 1.5,
      ),
      subtitle: Text(subtitle),
    );
  }
}
