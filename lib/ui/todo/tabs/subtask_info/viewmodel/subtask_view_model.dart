import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/bloc/resources/repository.dart';
import 'package:payment/models/groupmember.dart';
import 'package:payment/models/subtasks.dart';
import 'package:payment/bloc/resources/injection.dart';

class SubtaskViewModel {

  final Subtask subtask;
  final List<GroupMember> members;

  SubtaskViewModel(
      {
        required this.subtask,
      required this.members});

  String get title {
    return this.subtask.title;
  }

set priority(int index){
  subtask.priority=index;
}

  String get note {
    return this.subtask.note;
  }

  set note(String note) {
    subtask.note = note;
  }


  DateTime get deadline {
    return this.subtask.deadline;
  }

  set deadline(DateTime deadline) {
    subtask.deadline = deadline;
  }



  Future<void> getUsersAssignedtoSubtask() async {
    subtask.assignedTo =
        await repository.getUsersAssignedToSubtask(subtask.subtaskKey);
    //initialAssignedMembers = subtask.assignedTo;
    for (GroupMember user in members) {
      if (subtask.assignedTo.contains(user)) {
        selected(user, true);
      } else
        selected(user, false);
    }
  }
  void selected(GroupMember groupMember, bool selected) {
    groupMember.selectedForAssignment = selected;
  }

  bool alreadySelected(int index) => members[index].selectedForAssignment;

  Future<void> assignSubtaskToUser(int index) async {
    try {
      await repository.assignSubtaskToUser(
          subtask.subtaskKey, members[index].username);
    } catch (e) {
      throw e;
    }
  }

  Future<void> unassignSubtaskToUser(int index) async {
    try {
      await repository.unassignSubtaskToUser(
          subtask.subtaskKey, members[index].username);
    } catch (e) {
      throw e;
    }

  }


  Future<void> updateSubtaskInfo() async {
    print(this.subtask.priority);
    await locator<SubtaskBloc>().updateSubtaskInfo(this.subtask);
  }
}
