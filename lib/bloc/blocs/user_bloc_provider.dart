import 'package:payment/models/group.dart';
import 'package:payment/models/groupmember.dart';
import 'package:payment/models/message.dart';
import 'package:payment/models/subtasks.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:payment/models/tasks.dart';


class GroupBloc {
  final _groupSubject = BehaviorSubject<List<Group>>();
  var _role;

  List<Group> _groups = [];


  GroupBloc._privateConstructor();
  static final GroupBloc _instance = GroupBloc._privateConstructor();

  factory GroupBloc() {
    return _instance;
  }

  Stream<List<Group>> get getGroups {
    updateGroups();
    return _groupSubject.stream;
  }

  List<Group> getGroupList() {
    return _groups;
  }

  dynamic getroleList() {
    return _role;
  }

  Future<void> deleteGroup(String groupKey) async {
    await repository.deleteGroup(groupKey);
    await updateGroups();
  }

  Future<String> addGroup(String groupName, bool isPublic,String role) async {
    String groupKey = await repository.addGroup(groupName, isPublic,role);
    await updateGroups();
    return groupKey;
  }

  Future<void> updateGroups() async {
    List data;
    await Future<void>.delayed(const Duration(milliseconds: 150));
    data = await repository.getUserGroups();
    _groups=data[0];
    _role=data[1];
    _groupSubject.add(_groups);
  }
}



class TaskBloc {
  final _taskSubject = BehaviorSubject<List<Task>>();
  String _groupKey;

  TaskBloc(String groupKey) : this._groupKey = groupKey{
    updateTasks();
  }

  Stream<List<Task>> get getTasks {
   return _taskSubject.stream;
  }

  Future<void> addTask(String taskName) async {
    await repository.addTask(taskName, this._groupKey);
    await updateTasks();
  }

  Future<void> deleteTask(String taskKey) async {
    await repository.deleteTask(taskKey);
    await updateTasks();
  }

  Future<void> updateTask(Task task) async {
    await repository.updateTask(task);
    await updateTasks();
  }

  Future<void> updateTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    List<Task> tasks = await repository.getTasks(this._groupKey);
    _taskSubject.add(tasks);
  }

}

class SubtaskBloc {
  final _subtaskSubject = BehaviorSubject<List<Subtask>>();
  Task _task;

  SubtaskBloc(Task task) : this._task = task {
    _updateSubtasks();
  }

  Stream<List<Subtask>> get getSubtasks => _subtaskSubject.stream;

  Future<void> addSubtask(String subtaskName) async {
    Future.wait(
      [
        repository.addSubtask(_task.taskKey, subtaskName),
        _updateSubtasks(),
      ],
    );
  }

  Future<void> deleteSubtask(String subtaskKey) async {
    await repository.deleteSubtask(subtaskKey);
    await _updateSubtasks();
  }

  Future<void> updateSubtaskInfo(Subtask subtask) async {
        await repository.updateSubtask(subtask);
        await _updateSubtasks();

  }

  Future<void> _updateSubtasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    List<Subtask> subtasks = await repository.getSubtasks(_task);
    _subtaskSubject.add(subtasks);
  }
}

class messageBloc{
  final _messageSubject = BehaviorSubject<List<dynamic>>();
  String _subtaskKey;

  messageBloc(String subtaskKey) : this._subtaskKey = subtaskKey{
    updatemessage();
  }


  Stream<List<dynamic>> get getmessages {
    return _messageSubject.stream;
  }

  Future<void> addmessage(String message, String sender) async {
    await repository.send_message(message,sender,_subtaskKey);
    await updatemessage();
  }
  Future<void> updatemessage() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    List<dynamic> messages = await repository.get_message(_subtaskKey);
    _messageSubject.add(messages);
  }
}


final groupBloc = GroupBloc();
//final taskBloc = TaskBloc();
