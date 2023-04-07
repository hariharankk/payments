import 'package:flutter/material.dart';
import 'package:payment/ui/todo/tabs/todo_tab.dart';
import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/bloc/resources/repository.dart';
import 'package:payment/models/group.dart';
import 'package:payment/models/groupmember.dart';
import 'package:payment/services/Bloc.dart';

class GroupList extends StatefulWidget {
  /// The Page which the list tile will navigate to upon being clicked.
  ///
  /// Available Pages to Navigate To:
  /// * "ToDoTab"
  /// * "GroupInfoPage"

  /// The offset from the top.
  final double top;

  /// The offset from the left.
  final double left;

  /// The offset from the right.
  final double right;

  /// The offset from the bottom.
  final double bottom;

  /// Creates a visual Group List.
  GroupList(
      {
      this.top = 50,
      this.left = 30,
      this.right = 30,
      this.bottom = 50});

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<Group> groups = groupBloc.getGroupList();

  late Size mediaQuery;

  late double groupListItemWidth;

  late double groupListItemHeight;
  late double unitHeightValue, unitWidthValue;
  String role='';

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    mediaQuery = MediaQuery.of(context).size;
    groupListItemWidth = mediaQuery.width * 0.85;
    groupListItemHeight = mediaQuery.height * 0.17;
    return  _buildStreamBuilder();
  }

  StreamBuilder<List<Group>> _buildStreamBuilder() {
    return StreamBuilder(
      key: UniqueKey(),
      // Wrap our widget with a StreamBuilder
      stream: groupBloc.getGroups, // pass our Stream getter here
      initialData: groups, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container(
              child: Center(
                child: Text("No Connection"),
              ),
            );
          case ConnectionState.waiting:
            if (!snapshot.hasData) {
              //print("Waiting Data");
              return Center(child: CircularProgressIndicator());
            }
            break;
          case ConnectionState.active:
            //print("Active Data: " + snapshot.data.toString());
            if (snapshot.hasData) {
              groups = snapshot.data!;
              return buildGroupListView();
            }
            break;

        }
        return SizedBox.shrink();
      },
    );
  }

  Widget buildGroupListView() {
    return ListView.separated(
      padding: EdgeInsets.only(
          top: widget.top,
          left: widget.left,
          right: widget.right,
          bottom: widget.bottom),
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int index) {
        return Privacy_widget(groups[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 20,
        color: Colors.transparent,
      ),
    );
  }

  Widget buildWaitingScreen() {
    return  Center(
        child: CircularProgressIndicator()
     );
  }

  Widget Privacy_widget(Group group){
//    List<String> roles = group.members.map((element) => element.username==userBloc.getUserObject().username?element.role.trim():'').toList();
//    roles.removeWhere( (item) => item == '');
//    role = roles[0];
    role=GroupBloc().getroleList().containsKey(group.name)?GroupBloc().getroleList()[group.name]:null;
    print(role);
    return role == null ? buildWaitingScreen() :role=='Admin'? buildGroupListTile(group):role=='Worker'?workerbuildGroupListTile(group):visitorbuildGroupListTile(group);
    }

  Dismissible buildGroupListTile(Group group) {
    group.addListener(() {
      if (this.mounted) {
        setState(() {});
      }
    });
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(Icons.delete,
            color: Colors.black, size: 28 * unitHeightValue),
      ),
      onDismissed: (direction) async {
        if (group.members.length == 1) {
          await repository.deleteGroupMember(
              group.groupKey, userBloc.getUserObject()!.username!);
        } else if (group.members.length > 1) {
          try {
            await repository.deleteGroupMember(
                group.groupKey, userBloc.getUserObject().username!);
          } catch (e) {
            print(e);
          }
        }
      },
      direction: DismissDirection.endToStart,
      child: GestureDetector(
        onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ToDoTab(group: group)));
        },
        child: Container(
          height: groupListItemHeight,
          decoration: _tileDecoration(),
          child: _buildTilePadding(group),
        ),
      ),
    );
  }

  BoxDecoration _tileDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15.0,
          ),
        ]);
  }

  ///Tile Padding
  Padding _buildTilePadding(Group group) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 14),
      child: _tileRow(group),
    );
  }

  ///Tile Row
  Row _tileRow(Group group) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _groupInfoColumn(group),
      Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 24 * unitHeightValue,
      )
    ]);
  }

  ///Group Info
  Column _groupInfoColumn(Group group) {
    int groupSize = group.members.length;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGroupName(group),
          _buildGroupSize(groupSize),
          groupSize > 0
              ? _buildMemberAvatars(group.members)
              : SizedBox.shrink(),
        ]);
  }

  ///Build Group's Size
  Text _buildGroupSize(int groupSize) {
    return Text(
      groupSize == 1 ? "Private" : "$groupSize People",
      style: TextStyle(fontSize: 20 * unitHeightValue, color: Colors.blueGrey),
    );
  }

  ///Build Group's Name
  Text _buildGroupName(Group group) {
    return Text(
      group.name,
      style: TextStyle(
          fontSize: 25 * unitHeightValue,
          fontWeight: FontWeight.bold,
          color: Colors.blue),
    );
  }

  ///Build Member Avatar
  Row _buildMemberAvatars(List<GroupMember> members) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      for (int i = 0; i <= 7 && i < members.length; i++)
        Padding(
          padding: EdgeInsets.only(
              top: 8.0 * unitHeightValue, right: 5.0 * unitWidthValue),
          child:
              members[i].cAvatar(radius: 18, unitHeightValue: unitHeightValue),
        )
    ]);
  }

  GestureDetector workerbuildGroupListTile(Group group) {

    group.addListener(() {
      if (this.mounted) {
        setState(() {});
      }
    });
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WorkerToDoTab(group: group)));
      },
      child: Container(
        height: groupListItemHeight,
        decoration: _tileDecoration(),
        child: _buildTilePadding(group),
      ),
    );
  }

  GestureDetector visitorbuildGroupListTile(Group group) {
    group.addListener(() {
      if (this.mounted) {
        setState(() {});
      }
    });
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VisitorToDoTab(group: group)));
      },
      child: Container(
        height: groupListItemHeight,
        decoration: _tileDecoration(),
        child: _buildTilePadding(group),
      ),
    );
  }


}
