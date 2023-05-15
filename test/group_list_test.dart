  import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/models/group.dart';
import 'package:payment/ui/todo/tabs/todo_tab.dart';
import 'package:payment/widgets/group_list.dart';

void main() {
  
  final List<Group> mockGroups = [
    Group(name: 'Group 1', members: []),
    Group(name: 'Group 2', members: []),
    Group(name: 'Group 3', members: []),
  ];

  
  class MockUserBloc extends UserBloc {
    @override
    List<Group> getGroupList() {
      return mockGroups;
    }
  }

  setUp(() {
    
    userBloc = MockUserBloc();
  });

  testWidgets('GroupList widget displays group list correctly',
      (WidgetTester tester) async {
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GroupList(),
        ),
      ),
    );

    
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(GroupListTile), findsNWidgets(mockGroups.length));


    await tester.tap(find.byType(GroupListTile).first);
    await tester.pumpAndSettle();


    expect(find.byType(ToDoTab), findsOneWidget);
  });
}
