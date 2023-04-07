import  'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payment/ui/todo/tabs/subtask_info/viewmodel/subtask_view_model.dart';
import 'package:payment/ui/todo/tabs/subtask_info/widgets/due_date_row.dart';
import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/models/global.dart';
import 'package:payment/models/groupmember.dart';
import 'package:payment/models/subtasks.dart';
import 'package:payment/widgets/global_widgets/background_color_container.dart';
import 'package:payment/widgets/global_widgets/custom_appbar.dart';
import 'package:payment/widgets/task_widgets/priority.dart';
import 'package:payment/widgets/messagepage.dart';
import 'package:payment/bloc/resources/injection.dart';


class SubtaskInfo extends StatefulWidget {
  final List<GroupMember> members;
  final Subtask subtask;

  const SubtaskInfo({
    required this.subtask,
    required this.members,
  }) ;

  @override
  _SubtaskInfoState createState() => _SubtaskInfoState();
}

class _SubtaskInfoState extends State<SubtaskInfo> {
  late final SubtaskViewModel viewmodel;
  late double unitHeightValue, unitWidthValue;
  TextEditingController notesController = new TextEditingController();
  bool buffering = true;
  bool updating = false;
  final double fontSize= 32.0;
  late SubtaskBloc subtaskBloc;


  @override
  void initState() {
    viewmodel = SubtaskViewModel(
        subtask: widget.subtask,
        members: widget.members);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    subtaskBloc = locator<SubtaskBloc>();

    return SafeArea(
        child: BackgroundColorContainer(
          startColor: Colors.white,
          endColor: Colors.white,
          widget: Scaffold(
            appBar: AppBar(
              title: Text(''),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0.0,
              toolbarHeight: 100.0,
              leading: IconButton(
                tooltip: 'back',
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: <Widget>[
                SizedBox(width: 10,),
                IconButton(
                  onPressed: ()async{
                    deleteSubtask(widget.subtask);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Subtask " + widget.subtask.title + " Removed"),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          reAddSubtask(widget.subtask);
                        },
                      ),
                    ));
                    Navigator.pop(context);
                  },
                  icon: Icon(
                      Icons.delete,
                      size: 32.0 * unitHeightValue, color:Colors.blue),),
                SizedBox(width: 10,),


                PriorityPicker(colors: Colors.blue,onTap: (int value){
                  viewmodel.priority = value;
                  setState(() {});
                }
                ),
                SizedBox(width: 10,),
                Padding(
                  padding: EdgeInsets.only(
                      top:  5*unitHeightValue,
                      bottom: 5*unitHeightValue,
                      //right: 8.0 * unitWidthValue
                    //
                    ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                      backgroundColor: Colors.blue,
                      elevation: 9.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {
                        updating = true;
                      });
                      viewmodel.note = notesController.text;
                      viewmodel
                          .updateSubtaskInfo()
                          .then((_) => Navigator.pop(context));
                    },
                    child: updating
                        ? _buildProgressIndicator()
                        : Text(
                            "Update",
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13 * unitHeightValue,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                SizedBox(width: 5,),
              ],
            ),
            backgroundColor: Colors.grey.shade100,
            body:
              SingleChildScrollView(
                child: FutureBuilder(
                  future: viewmodel.getUsersAssignedtoSubtask(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      buffering = true;
                    else
                      buffering = false;
                    return _buildBody();
                  },
                ),
              ),
            ),
          ),
        );
  }

  Center _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  void reAddSubtask(Subtask subtask) async {
    await subtaskBloc.addSubtask(subtask.title);
  }

  Future<Null> deleteSubtask(Subtask subtask) async {
    await subtaskBloc.deleteSubtask(subtask.subtaskKey);
  }

  Column _buildBody() {
    return
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _subtaskInfoColumn(),
          ),
          _buildExpandedCard(),
          ChatScreen(subtaskKey: widget.subtask.subtaskKey),
        ],
      );
  }

  /// Column containing pertinent Subtask Info
  Column _subtaskInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25.0 * unitHeightValue),
        Center(
          child: Text(
            widget.subtask.title,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: fontSize * unitHeightValue,
            ),
          ),
        ),
        SizedBox(height: 25.0 * unitHeightValue),
        Text("Details", style: labelStyle1(unitHeightValue)),
        SizedBox(height: 15.0 * unitHeightValue),
        _notesContainer(),
        SizedBox(height: 25 * unitHeightValue),
        DueDateRow(viewmodel),
        SizedBox(height: 25 * unitHeightValue),
      ],
    );
  }


  /// Container for Notes
  ///
  /// Contains
  /// * Container
  /// * Textfield for editing notes
  Container _notesContainer() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: notesController..text = viewmodel.note,
        onChanged: (val) {
          viewmodel.note = val;
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        decoration: InputDecoration(border: InputBorder.none),
        style: TextStyle(fontSize: 16 * unitHeightValue,color: Colors.black),
      ),
    );
  }

  Container _buildExpandedCard() {
    return Container(
      height: MediaQuery.of(context).size.height/2.5,
      width: MediaQuery.of(context).size.width,
      child: _buildMembersContainer(),
    );
  }

  Container _buildMembersContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          _buildMembersLabelRow(),
          buffering ? _buildProgressIndicator() : _buildMembersList(),
        ],
      ),
    );
  }

  Row _buildMembersLabelRow() {
    return Row(children: [
      Text(
        "Assigned",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      ),
      SizedBox(width: 5 * unitWidthValue),
      CircleAvatar(
        radius: 20 * unitHeightValue,
        backgroundColor: Colors.blue,
        child: Text(
          "${widget.subtask.assignedTo.length}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16 * unitHeightValue),
        ),
      ),
      SizedBox(width: 5 * unitWidthValue),
      widget.subtask.assignedTo.length > 1
      ?Text("people",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      )
    :Text("person",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontSize: 22 * unitHeightValue),
      )
    ]);
  }

  Padding _buildMembersList() {
    return Padding(
      padding: EdgeInsets.only(
          top: 75.0 * unitHeightValue, right: 24.0 * unitWidthValue),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200 * unitWidthValue,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10 * unitWidthValue,
          mainAxisSpacing: 10 * unitHeightValue,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              try {
                viewmodel.alreadySelected(index)
                    ? await viewmodel.unassignSubtaskToUser(index)
                    : await viewmodel.assignSubtaskToUser(index);
                setState(() {});
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$e"), backgroundColor: Colors.red),
                );
              }
            },
            child: Column(
              children: [
                viewmodel.members[index].cAvatar(
                    radius: 34,
                    color: Colors.blue,
                    unitHeightValue: unitHeightValue),
                Text(
                  viewmodel.members[index].name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * unitHeightValue,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: viewmodel.members.length,
      ),
    );
  }
}


class VisitorSubtaskInfo extends StatefulWidget {
  final List<GroupMember> members;
  final Subtask subtask;

  const VisitorSubtaskInfo({
    required this.subtask,
    required this.members,
  }) ;

  @override
  _VisitorSubtaskInfoState createState() => _VisitorSubtaskInfoState();
}

class _VisitorSubtaskInfoState extends State<VisitorSubtaskInfo> {
  late final SubtaskViewModel viewmodel;
  late double unitHeightValue, unitWidthValue;
  TextEditingController notesController = new TextEditingController();
  bool buffering = true;
  bool updating = false;

  @override
  void initState() {
    viewmodel = SubtaskViewModel(
        subtask: widget.subtask,
        members: widget.members);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: Scaffold(
          appBar: CustomAppBar(
            widget.subtask.title,
            leading: IconButton(
              tooltip: 'Back',
              icon: Icon(Icons.arrow_back,
                  size: 32.0 * unitHeightValue, color: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
           ),
          backgroundColor: Colors.grey.shade200,
          body:
          SingleChildScrollView(
            child: FutureBuilder(
              future: viewmodel.getUsersAssignedtoSubtask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  buffering = true;
                else
                  buffering = false;
                return _buildBody();
              },
            ),
          ),
        ),
      ),
    );
  }

  Center _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  Column _buildBody() {
    return
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _subtaskInfoColumn(),
          ),
          _buildExpandedCard(),
          ChatScreen(subtaskKey: widget.subtask.subtaskKey),
        ],
      );
  }

  /// Column containing pertinent Subtask Info
  Column _subtaskInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Details", style: labelStyle(unitHeightValue)),
        SizedBox(height: 10.0 * unitHeightValue),
        _notesContainer(),
        SizedBox(height: 20 * unitHeightValue),
        VisitorDueDateRow(viewmodel),
        SizedBox(height: 15 * unitHeightValue),
      ],
    );
  }


  /// Container for Notes
  ///
  /// Contains
  /// * Container
  /// * Textfield for editing notes
  Container _notesContainer() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        enabled: false,
        controller: notesController..text = viewmodel.note,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        decoration: InputDecoration(border: InputBorder.none),
        style: TextStyle(fontSize: 16 * unitHeightValue,color: Colors.black),
      ),
    );
  }

  Container _buildExpandedCard() {
    return Container(
      height: MediaQuery.of(context).size.height/2.5,
      width: MediaQuery.of(context).size.width,
      child: _buildMembersContainer(),
    );
  }

  Container _buildMembersContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          _buildMembersLabelRow(),
          buffering ? _buildProgressIndicator() : _buildMembersList(),
        ],
      ),
    );
  }

  Row _buildMembersLabelRow() {
    return Row(children: [
      Text(
        "Assigned : ",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      ),
      SizedBox(width: 5 * unitWidthValue),
      CircleAvatar(
        radius: 20 * unitHeightValue,
        backgroundColor: Colors.blue,
        child: Text(
          "${widget.subtask.assignedTo.length}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16 * unitHeightValue),
        ),
      ),
      SizedBox(width: 5 * unitWidthValue),
      widget.subtask.assignedTo.length > 1
          ?Text("people",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      )
          :Text("person",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      )
    ]);
  }

  Padding _buildMembersList() {
    return Padding(
      padding: EdgeInsets.only(
          top: 75.0 * unitHeightValue, right: 24.0 * unitWidthValue),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200 * unitWidthValue,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10 * unitWidthValue,
          mainAxisSpacing: 10 * unitHeightValue,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: ()  {
            },
            child: Column(
              children: [
                viewmodel.members[index].cAvatar(
                    radius: 34,
                    color: Colors.blue,
                    unitHeightValue: unitHeightValue),
                Text(
                  viewmodel.members[index].name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * unitHeightValue,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: viewmodel.members.length,
      ),
    );
  }
}


class WorkerSubtaskInfo extends StatefulWidget {
  final List<GroupMember> members;
  final Subtask subtask;

  const WorkerSubtaskInfo({
    required this.subtask,
    required this.members,
  }) ;

  @override
  _WorkerSubtaskInfoState createState() => _WorkerSubtaskInfoState();
}

class _WorkerSubtaskInfoState extends State<WorkerSubtaskInfo> {
  late final SubtaskViewModel viewmodel;
  late double unitHeightValue, unitWidthValue;
  TextEditingController notesController = new TextEditingController();
  bool buffering = true;
  bool updating = false;
  final double fontSize= 32.0;
  late SubtaskBloc subtaskBloc;


  @override
  void initState() {
    viewmodel = SubtaskViewModel(
        subtask: widget.subtask,
        members: widget.members);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    subtaskBloc = locator<SubtaskBloc>();

    return SafeArea(
      child: BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: Scaffold(
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            toolbarHeight: 100.0,
            leading: IconButton(
              tooltip: 'பின்னால்',
              icon: Icon(Icons.arrow_back,
                  size: 32.0 * unitHeightValue, color: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            actions: <Widget>[
              SizedBox(width: 10,),
              PriorityPicker(colors: Colors.blue,onTap: (int value){
                viewmodel.priority = value;
                setState(() {});
              }
              ),
              SizedBox(width: 10,),
              Padding(
                padding: EdgeInsets.only(
                  top:  5*unitHeightValue,
                  bottom: 5*unitHeightValue,
                  //right: 8.0 * unitWidthValue
                  //
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    backgroundColor: Colors.blue,
                    elevation: 9.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                    if (!mounted) return;
                    setState(() {
                      updating = true;
                    });
                    viewmodel.note = notesController.text;
                    viewmodel
                        .updateSubtaskInfo()
                        .then((_) => Navigator.pop(context));
                  },
                  child: updating
                      ? _buildProgressIndicator()
                      : Text(
                    "Update",
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13 * unitHeightValue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 5,),
            ],
          ),
          backgroundColor: Colors.grey.shade100,
          body:
          SingleChildScrollView(
            child: FutureBuilder(
              future: viewmodel.getUsersAssignedtoSubtask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  buffering = true;
                else
                  buffering = false;
                return _buildBody();
              },
            ),
          ),
        ),
      ),
    );
  }

  Center _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  void reAddSubtask(Subtask subtask) async {
    await subtaskBloc.addSubtask(subtask.title);
  }

  Future<Null> deleteSubtask(Subtask subtask) async {
    await subtaskBloc.deleteSubtask(subtask.subtaskKey);
  }

  Column _buildBody() {
    return
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _subtaskInfoColumn(),
          ),
          _buildExpandedCard(),
          ChatScreen(subtaskKey: widget.subtask.subtaskKey),
        ],
      );
  }

  /// Column containing pertinent Subtask Info
  Column _subtaskInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25.0 * unitHeightValue),
        Center(
          child: Text(
            widget.subtask.title,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: fontSize * unitHeightValue,
            ),
          ),
        ),
        SizedBox(height: 25.0 * unitHeightValue),
        Text("Notes", style: labelStyle1(unitHeightValue)),
        SizedBox(height: 15.0 * unitHeightValue),
        _notesContainer(),
        SizedBox(height: 25 * unitHeightValue),
        DueDateRow(viewmodel),
        SizedBox(height: 25 * unitHeightValue),
      ],
    );
  }


  /// Container for Notes
  ///
  /// Contains
  /// * Container
  /// * Textfield for editing notes
  Container _notesContainer() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: notesController..text = viewmodel.note,
        onChanged: (val) {
          viewmodel.note = val;
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        decoration: InputDecoration(border: InputBorder.none),
        style: TextStyle(fontSize: 16 * unitHeightValue,color: Colors.black),
      ),
    );
  }

  Container _buildExpandedCard() {
    return Container(
      height: MediaQuery.of(context).size.height/2.5,
      width: MediaQuery.of(context).size.width,
      child: _buildMembersContainer(),
    );
  }

  Container _buildMembersContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          _buildMembersLabelRow(),
          buffering ? _buildProgressIndicator() : _buildMembersList(),
        ],
      ),
    );
  }

  Row _buildMembersLabelRow() {
    return Row(children: [
      Text(
        "Assigned : ",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      ),
      SizedBox(width: 5 * unitWidthValue),
      CircleAvatar(
        radius: 20 * unitHeightValue,
        backgroundColor: Colors.blue,
        child: Text(
          "${widget.subtask.assignedTo.length}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16 * unitHeightValue),
        ),
      ),
      SizedBox(width: 5 * unitWidthValue),
      widget.subtask.assignedTo.length > 1
          ?Text("people",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      )
          :Text("person",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22 * unitHeightValue),
      )
    ]);
  }

  Padding _buildMembersList() {
    return Padding(
      padding: EdgeInsets.only(
          top: 75.0 * unitHeightValue, right: 24.0 * unitWidthValue),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200 * unitWidthValue,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10 * unitWidthValue,
          mainAxisSpacing: 10 * unitHeightValue,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              try {
                viewmodel.alreadySelected(index)
                    ? await viewmodel.unassignSubtaskToUser(index)
                    : await viewmodel.assignSubtaskToUser(index);
                setState(() {});
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$e"), backgroundColor: Colors.red),
                );
              }
            },
            child: Column(
              children: [
                viewmodel.members[index].cAvatar(
                    radius: 34,
                    color: Colors.blue,
                    unitHeightValue: unitHeightValue),
                Text(
                  viewmodel.members[index].name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * unitHeightValue,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: viewmodel.members.length,
      ),
    );
  }
}
