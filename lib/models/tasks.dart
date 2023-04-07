import 'package:equatable/equatable.dart';
import 'package:payment/models/subtasks.dart';

// ignore: must_be_immutable
class Task extends Equatable {
  /// Task Name/Title
  String title;

  /// Task ID

  /// Task Key
  String taskKey;

  /// List of Subtasks associated with the Task
  List<Subtask> subtasks = [];

  /// GroupKey from the Group that added the task
  String groupKey;

  /// Name of Group that added the task


  /// Has the Task been completed
  bool completed;

  int priority;

  /// Time Created
  DateTime timeCreated;

  /// Time Updated
  DateTime timeUpdated;


  Task(
      {required this.title,
      required this.groupKey,
      required this.completed,
      required this.priority,
      required this.taskKey,
      required this.timeCreated,
      required this.timeUpdated,
});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        title: parsedJson['title'],
        taskKey: parsedJson['task_key'],
        completed: parsedJson['completed'],
        priority: parsedJson['priority'],
        groupKey: parsedJson['group_key'],
        timeCreated: DateTime.parse(parsedJson['time_created']),
        timeUpdated: DateTime.parse(parsedJson['time_updated']),
        );
  }

  @override
  List<Object> get props => [taskKey];

  @override
  String toString() {
    return "Task Name: $title, Subtasks: ${subtasks.length}";
  }
}
