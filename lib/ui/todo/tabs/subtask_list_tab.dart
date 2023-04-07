import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payment/ui/todo/title_card.dart';
import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/models/global.dart';
import 'package:payment/models/group.dart';
import 'package:payment/models/subtasks.dart';
import 'package:payment/models/tasks.dart';
import 'package:payment/widgets/global_widgets/background_color_container.dart';
import 'package:payment/widgets/task_widgets/add_subtask_widget.dart';
import 'package:payment/widgets/task_widgets/subtask_list_item_widget.dart';
import 'package:payment/widgets/task_widgets/priority.dart';
import 'package:payment/bloc/resources/injection.dart';

class SubtaskListTab extends StatefulWidget {
  final Group group;
  final Task task;


  SubtaskListTab({required this.group, required this.task});

  @override
  _SubtaskListTabState createState() => _SubtaskListTabState();
}

class _SubtaskListTabState extends State<SubtaskListTab> {

  late TaskBloc taskBloc;
  late SubtaskBloc subtaskBloc;
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _SubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    task = widget.task;
    group = widget.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    locator.registerLazySingleton<SubtaskBloc>(() =>SubtaskBloc(task));
    subtaskBloc = locator<SubtaskBloc>();
    taskBloc = locator<TaskBloc>();

    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Subtasks',
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: [
                SizedBox(width: 10,),
                IconButton(
                  onPressed: ()async{
                    await deleteTask(widget.task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task " + widget.task.title + " Removed"),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            reAddTask(widget.task);
                          },
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(
                      Icons.delete,
                      size: 32.0 * unitHeightValue, color:Colors.white),),
                SizedBox(width: 10,),

                _popupMenuButton(),
                SizedBox(width: 10,),
                PriorityPicker(colors: Colors.white,onTap: (int value){
                  widget.task.priority = value;
                  locator<TaskBloc>().updateTask(widget.task);
                  setState(() {});
                } ),
                SizedBox(width: 5,)
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget:
                      TitleCard(title: task.title, child: _buildStreamBuilder()),
                ),
                AddSubtask(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void reAddTask(Task task) async {
    await taskBloc.addTask(task.title).then((value) {
    });
  }

  Future<Null> deleteTask(Task task) async {
    await taskBloc.deleteTask(task.taskKey).then((value) {
    });
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
        children: task.subtasks.map<Column>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }
  Column _buildListTile(Subtask subtask) {
    return Column(
        children: <Widget>[
          Container(
            key:   Key(subtask.title),
            padding: EdgeInsets.only(left: 10.0,right: 10.0),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: SubtaskListItemWidget(
              subtask: subtask,
              group: group,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,)
        ],
      );
  }




  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: Colors.white),
      color: Colors.white,
      tooltip: 'Order_by',
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "Alphabetical",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 20 * unitHeightValue, color: Colors.blue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Alphabetical",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "New-Old",
          child: Row(children: [
            Icon(Icons.date_range, size: 20 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "New-Old",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Old-New",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue,  size: 20 * unitHeightValue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Old-New",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Deadline",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue, size: 20 * unitHeightValue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Deadline",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "Alphabetical":
        task.subtasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "New-Old":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "Old-New":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "Deadline":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "பழமையான-அண்மையில்";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}

class WorkerSubtaskListTab extends StatefulWidget {
  final Group group;
  final Task task;


  WorkerSubtaskListTab({required this.group, required this.task});

  @override
  _WorkerSubtaskListTabState createState() => _WorkerSubtaskListTabState();
}

class _WorkerSubtaskListTabState extends State<WorkerSubtaskListTab> {

  late SubtaskBloc subtaskBloc;
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _WorkerSubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    task = widget.task;
    group = widget.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    locator.registerLazySingleton<SubtaskBloc>(() =>SubtaskBloc(task));
    subtaskBloc = locator<SubtaskBloc>();

    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'SubTask',
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: [
                SizedBox(width: 10,),
                _popupMenuButton(),
                SizedBox(width: 10,),
                PriorityPicker(colors: Colors.white,onTap: (int value){
                  widget.task.priority = value;
                  locator<TaskBloc>().updateTask(widget.task);
                  setState(() {});
                } ),
                SizedBox(width: 5,)
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget:
                  TitleCard(title: task.title, child: _buildStreamBuilder()),
                ),
                AddSubtask(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
        children: task.subtasks.map<Column>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }
  Column _buildListTile(Subtask subtask) {
    return Column(
      children: <Widget>[
        Container(
          key:   Key(subtask.title),
          padding: EdgeInsets.only(left: 10.0,right: 10.0),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: WorkerSubtaskListItemWidget(
            subtask: subtask,
            group: group,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02,)
      ],
    );
  }




  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: Colors.white),
      color: Colors.white,
      tooltip: 'Orderby',
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "Alphabetical",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 20 * unitHeightValue, color: Colors.blue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Alphabetical",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "New-Old",
          child: Row(children: [
            Icon(Icons.date_range, size: 20 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "New-Old",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Old-New",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue,  size: 20 * unitHeightValue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Old-New",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Deadline",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue, size: 20 * unitHeightValue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Deadline",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "Alphabetical":
        task.subtasks.sort(
                (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "New-Old":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "Old-New":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "Deadline":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "பழமையான-அண்மையில்";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }

}

class VisitorSubtaskListTab extends StatefulWidget {
  final Group group;
  final Task task;


  VisitorSubtaskListTab({required this.group, required this.task});

  @override
  _VisitorSubtaskListTabState createState() => _VisitorSubtaskListTabState();
}

class _VisitorSubtaskListTabState extends State<VisitorSubtaskListTab> {

  late SubtaskBloc subtaskBloc;
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _VisitorSubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    task = widget.task;
    group = widget.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    locator.registerLazySingleton<SubtaskBloc>(() =>SubtaskBloc(task));
    subtaskBloc = locator<SubtaskBloc>();

    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Subtasks',
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: [
                SizedBox(width: 10,),
                _popupMenuButton(),
                SizedBox(width: 10,),
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget:
                  TitleCard(title: task.title, child: _buildStreamBuilder()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
        children: task.subtasks.map<Column>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }
  Column _buildListTile(Subtask subtask) {
    return Column(
      children: <Widget>[
        Container(
          key:   Key(subtask.title),
          padding: EdgeInsets.only(left: 10.0,right: 10.0),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: VisitorSubtaskListItemWidget(
            subtask: subtask,
            group: group,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02,)
      ],
    );
  }




  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: Colors.white),
      color: Colors.white,
      tooltip: 'Order_by',
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "Alphabetical",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 20 * unitHeightValue, color: Colors.blue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Alphabetical",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "New-Old",
          child: Row(children: [
            Icon(Icons.date_range, size: 20 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "New-Old",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Old-New",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue,  size: 20 * unitHeightValue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Old-New",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Deadline",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue, size: 20 * unitHeightValue),
            SizedBox(width: 5.0 * unitWidthValue),
            Text(
              "Deadline",
              style: TextStyle(
                  color: Colors.blue, fontSize: 17 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "Alphabetical":
        task.subtasks.sort(
                (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "New-Old":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "Old-New":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "Deadline":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "பழமையான-அண்மையில்";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}


