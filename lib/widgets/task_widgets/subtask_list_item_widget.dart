import 'package:flutter/material.dart';
import 'package:payment/ui/todo/tabs/subtask_info/subtask_info_tab.dart';
import 'package:payment/bloc/resources/repository.dart';
import 'package:payment/models/global.dart';
import 'package:payment/models/group.dart';
import 'package:payment/models/subtasks.dart';
import 'package:payment/widgets/task_widgets/priority box.dart';

class SubtaskListItemWidget extends StatefulWidget {
  final Subtask subtask;
  final Group group;

  SubtaskListItemWidget(
      {required this.subtask, required this.group});
  @override
  _SubtaskListItemWidgetState createState() => _SubtaskListItemWidgetState();
}

class _SubtaskListItemWidgetState extends State<SubtaskListItemWidget> {
  late double listItemWidth,listItemHeight;
  late Size mediaQuery;
  bool change = false;
  late double unitHeightValue, unitWidthValue;
  //
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    mediaQuery = MediaQuery.of(context).size;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;

    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SubtaskInfo(
          subtask: widget.subtask,
          members: widget.group.members,
        );
      })),
      child: altTile(),
    );
  }

  Container altTile() {
    return Container(
      height: listItemHeight,
      width: listItemWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15.0,
            ),
          ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: listItemHeight,
              width: listItemWidth * 0.8,
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Checkbox(
                        value: widget.subtask.completed,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.subtask.completed = newValue!;
                            repository.updateSubtask(widget.subtask);
                          });
                        }),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.subtask.title,
                          style: toDoListTileStyle(unitHeightValue),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(height: 10,),
                        widget.subtask.note.isNotEmpty
                            ? Expanded(
                              child: Text(
                                  widget.subtask.note,
                                  style: toDoListTiletimeStyle(unitHeightValue),
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  maxLines: 1,
                                ),
                            )
                            : Text(
                                "No Notes",
                                style: toDoListTilesubtimeStyle(unitHeightValue)
                              ),
                        SizedBox(height: 10,),
                        widget.subtask.assignedTo.length > 0
                            ? _buildAssignedMemberAvatars()
                            : Text(
                                "No Assigned Members",
                                style: toDoListTilesubtimeStyle(unitHeightValue),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            Row(
            children: [
              Icon(Icons.calendar_today,
                  color: Colors.blue, size: 20 * unitHeightValue),
              SizedBox(width: 5 * unitWidthValue),
              Text(
              "Deadline: ${widget.subtask.deadline.month}/${widget.subtask.deadline.day}/${widget.subtask.deadline.year}",
                style: toDoListTiletimeStyle(unitHeightValue*0.7),
               ),
            ],
          ),

               Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child:
                  box(index: widget.subtask.priority,height: unitHeightValue*boxlength,width: unitWidthValue*boxwidth,),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildAssignedMemberAvatars() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      for (int i = 0; i < 7 && i < widget.subtask.assignedTo.length; i++)
        Padding(
          padding: EdgeInsets.only(
              top: 8.0 * unitHeightValue, right: 5.0 * unitWidthValue),
          child: widget.subtask.assignedTo[i]
              .cAvatar(radius: 18, unitHeightValue: unitHeightValue),
        )
    ]);
  }
}

class WorkerSubtaskListItemWidget extends StatefulWidget {
  final Subtask subtask;
  final Group group;

  WorkerSubtaskListItemWidget(
      {required this.subtask, required this.group});
  @override
  _WorkerSubtaskListItemWidgetState createState() => _WorkerSubtaskListItemWidgetState();
}

class _WorkerSubtaskListItemWidgetState extends State<WorkerSubtaskListItemWidget> {
  late Size mediaQuery;
  late double listItemHeight,listItemWidth;
  bool change = false;
  late double unitHeightValue, unitWidthValue;
  //
  //
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    mediaQuery = MediaQuery.of(context).size;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;

    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return WorkerSubtaskInfo(
              subtask: widget.subtask,
              members: widget.group.members,
            );
          })),
      child: altTile(),
    );
  }

  Container altTile() {
    return Container(
      height: listItemHeight,
      width: listItemWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15.0,
            ),
          ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: listItemHeight,
              width: listItemWidth * 0.8,
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Checkbox(
                        value: widget.subtask.completed,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.subtask.completed = newValue!;
                            repository.updateSubtask(widget.subtask);
                          });
                        }),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.subtask.title,
                          style: toDoListTileStyle(unitHeightValue),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(height: 10,),
                        widget.subtask.note.isNotEmpty
                            ? Expanded(
                          child: Text(
                            widget.subtask.note,
                            style: toDoListTiletimeStyle(unitHeightValue),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            maxLines: 1,
                          ),
                        )
                            : Text(
                            "No Notes",
                            style: toDoListTilesubtimeStyle(unitHeightValue)
                        ),
                        SizedBox(height: 10,),
                        widget.subtask.assignedTo.length > 0
                            ? _buildAssignedMemberAvatars()
                            : Text(
                          "No Assigned Members",
                          style: toDoListTilesubtimeStyle(unitHeightValue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.blue, size: 20 * unitHeightValue),
                    SizedBox(width: 5 * unitWidthValue),
                    Text(
                      "Deadline: ${widget.subtask.deadline.month}/${widget.subtask.deadline.day}/${widget.subtask.deadline.year}",
                      style: toDoListTiletimeStyle(unitHeightValue*0.7),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child:
                  box(index: widget.subtask.priority,height: unitHeightValue*boxlength,width: unitWidthValue*boxwidth,),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildAssignedMemberAvatars() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      for (int i = 0; i < 7 && i < widget.subtask.assignedTo.length; i++)
        Padding(
          padding: EdgeInsets.only(
              top: 8.0 * unitHeightValue, right: 5.0 * unitWidthValue),
          child: widget.subtask.assignedTo[i]
              .cAvatar(radius: 18, unitHeightValue: unitHeightValue),
        )
    ]);
  }
}

class VisitorSubtaskListItemWidget extends StatefulWidget {
  final Subtask subtask;
  final Group group;

  VisitorSubtaskListItemWidget(
      {required this.subtask, required this.group});
  @override
  _VisitorSubtaskListItemWidgetState createState() => _VisitorSubtaskListItemWidgetState();
}

class _VisitorSubtaskListItemWidgetState extends State<VisitorSubtaskListItemWidget> {
  late double listItemWidth;
  late Size mediaQuery;
  late double listItemHeight;
  bool change = false;
  late double unitHeightValue, unitWidthValue;
  //
  //
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    mediaQuery = MediaQuery.of(context).size;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;

    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return VisitorSubtaskInfo(
              subtask: widget.subtask,
              members: widget.group.members,
            );
          })),
      child: altTile(),
    );
  }

  Container altTile() {
    return Container(
      height: listItemHeight,
      width: listItemWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15.0,
            ),
          ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: listItemHeight,
              width: listItemWidth * 0.8,
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Checkbox(
                        value: widget.subtask.completed,
                        onChanged: (bool? newValue) {
                          setState(() {
                          });
                        }),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.subtask.title,
                          style: toDoListTileStyle(unitHeightValue),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(height: 10,),
                        widget.subtask.note.isNotEmpty
                            ? Expanded(
                          child: Text(
                            widget.subtask.note,
                            style: toDoListTiletimeStyle(unitHeightValue),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            maxLines: 1,
                          ),
                        )
                            : Text(
                            "No Notes",
                            style: toDoListTilesubtimeStyle(unitHeightValue)
                        ),
                        SizedBox(height: 10,),
                        widget.subtask.assignedTo.length > 0
                            ? _buildAssignedMemberAvatars()
                            : Text(
                          "No Assigned Members",
                          style: toDoListTilesubtimeStyle(unitHeightValue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.blue, size: 20 * unitHeightValue),
                    SizedBox(width: 5 * unitWidthValue),
                    Text(
                      "Deadline: ${widget.subtask.deadline.month}/${widget.subtask.deadline.day}/${widget.subtask.deadline.year}",
                      style: toDoListTiletimeStyle(unitHeightValue*0.7),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child:
                  box(index: widget.subtask.priority,height: unitHeightValue*boxlength,width: unitWidthValue*boxwidth,),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildAssignedMemberAvatars() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      for (int i = 0; i < 7 && i < widget.subtask.assignedTo.length; i++)
        Padding(
          padding: EdgeInsets.only(
              top: 8.0 * unitHeightValue, right: 5.0 * unitWidthValue),
          child: widget.subtask.assignedTo[i]
              .cAvatar(radius: 18, unitHeightValue: unitHeightValue),
        )
    ]);
  }
}
