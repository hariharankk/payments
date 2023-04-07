import 'package:flutter/material.dart';
import 'package:payment/widgets/task_widgets/priority box.dart';
import 'package:payment/ui/todo/tabs/subtask_list_tab.dart';
import 'package:payment/bloc/resources/repository.dart';
import 'package:payment/models/global.dart';
import 'package:payment/models/group.dart';
import 'package:payment/models/tasks.dart';

class TaskListItemWidget extends StatefulWidget {
  final Task task;
  final Group group;

  TaskListItemWidget({required this.group, required this.task});

  @override
  _TaskListItemWidgetState createState() => _TaskListItemWidgetState();
}

class _TaskListItemWidgetState extends State<TaskListItemWidget> {
  late double unitHeightValue , unitWidthValue;
  late double height;
  late double listItemHeight,listItemWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    unitHeightValue = mediaQuery.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    height = mediaQuery.height * 0.1;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;


    return  GestureDetector(
        key: UniqueKey(),
        onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => SubtaskListTab(group:widget.group, task:widget.task)));
                 },

        child: Container(
            height: height,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 25.0,
                ),
              ],
            ),
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: listItemHeight,
                      width: listItemWidth * 0.8,
                      padding: EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Checkbox(
                                value: widget.task.completed,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    widget.task.completed = newValue!;
                                    repository.updateTask(widget.task);
                                  });
                                }),
                          ),
                          SizedBox(width: 5,),


                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                    widget.task.title,
                                    style: toDoListTileStyle(unitHeightValue),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ],
                          ),
                        )
                       ],
                      ),
                     ),
                  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                         children: <Widget>[
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Icon(Icons.calendar_today,
                                   color: Colors.blue, size: 20 * unitHeightValue),
                               SizedBox(width: 5 * unitWidthValue),
                               Text(
                                 "உருவாக்கப்பட்டது: ${widget.task.timeCreated.toString().substring(0,11)}",
                                 style: toDoListTiletimeStyle(unitHeightValue*0.7),
                               ),
                              ]
                            ),
                           //Padding(
                           //  padding: const EdgeInsets.only(left: 100.0),
                             //child:
                             box(
                             index: widget.task.priority,
                             height: unitHeightValue*boxlength,
                             width: unitWidthValue*boxwidth,),
                           //),

                         ],
                         ),
                     ]
                    ),
                   ),
            )

    );
  }
}


class WorkerTaskListItemWidget extends StatefulWidget {
  final Task task;
  final Group group;

  WorkerTaskListItemWidget({required this.group, required this.task});

  @override
  _WorkerTaskListItemWidgetState createState() => _WorkerTaskListItemWidgetState();
}

class _WorkerTaskListItemWidgetState extends State<WorkerTaskListItemWidget> {
  late double unitHeightValue , unitWidthValue;
  late double height;
  late double listItemHeight,listItemWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    unitHeightValue = mediaQuery.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    height = mediaQuery.height * 0.1;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;
    print('workertask');


    return  GestureDetector(
        key: UniqueKey(),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerSubtaskListTab(group:widget.group, task:widget.task)));
        },

        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25.0,
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: listItemHeight,
                    width: listItemWidth * 0.8,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Checkbox(
                              value: widget.task.completed,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  widget.task.completed = newValue!;
                                  repository.updateTask(widget.task);
                                });
                              }),
                        ),
                        SizedBox(width: 5,),


                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.task.title,
                                style: toDoListTileStyle(unitHeightValue),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.blue, size: 20 * unitHeightValue),
                            SizedBox(width: 5 * unitWidthValue),
                            Text(
                              "உருவாக்கப்பட்டது: ${widget.task.timeCreated.toString().substring(0,11)}",
                              style: toDoListTiletimeStyle(unitHeightValue*0.7),
                            ),
                          ]
                      ),
                      //Padding(
                      //  padding: const EdgeInsets.only(left: 100.0),
                      //child:
                      box(
                        index: widget.task.priority,
                        height: unitHeightValue*boxlength,
                        width: unitWidthValue*boxwidth,),
                      //),

                    ],
                  ),
                ]
            ),
          ),
        )

    );
  }
}


class VisitorTaskListItemWidget extends StatefulWidget {
  final Task task;
  final Group group;

  VisitorTaskListItemWidget({required this.group, required this.task});

  @override
  _VisitorTaskListItemWidgetState createState() => _VisitorTaskListItemWidgetState();
}

class _VisitorTaskListItemWidgetState extends State<VisitorTaskListItemWidget> {
  late double unitHeightValue , unitWidthValue;
  late double height;
  late double listItemHeight,listItemWidth;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    unitHeightValue = mediaQuery.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    height = mediaQuery.height * 0.1;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;
    print('visitortask');


    return  GestureDetector(
        key: UniqueKey(),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => VisitorSubtaskListTab(group:widget.group, task:widget.task)));
        },

        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25.0,
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: listItemHeight,
                    width: listItemWidth * 0.8,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Checkbox(
                              value: widget.task.completed,
                              onChanged: (bool? newValue) {
                                setState(() {
                                });
                              }),
                        ),
                        SizedBox(width: 5,),


                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.task.title,
                                style: toDoListTileStyle(unitHeightValue),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.blue, size: 20 * unitHeightValue),
                            SizedBox(width: 5 * unitWidthValue),
                            Text(
                              "உருவாக்கப்பட்டது: ${widget.task.timeCreated.toString().substring(0,11)}",
                              style: toDoListTiletimeStyle(unitHeightValue*0.7),
                            ),
                          ]
                      ),
                      //Padding(
                      //  padding: const EdgeInsets.only(left: 100.0),
                      //child:
                      box(
                        index: widget.task.priority,
                        height: unitHeightValue*boxlength,
                        width: unitWidthValue*boxwidth,),
                      //),

                    ],
                  ),
                ]
            ),
          ),
        )

    );
  }
}
