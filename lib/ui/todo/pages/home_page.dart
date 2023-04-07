import 'package:flutter/material.dart';
import 'package:payment/ui/todo/pages/sidebar_pages/create_new_group_page.dart';
import 'package:payment/ui/todo/tabs/list_groups_tab.dart';

import 'package:payment/models/global.dart';

class Groups extends StatefulWidget {

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  late double unitHeightValue, unitWidthValue;


  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Teams", style: appTitleStyle(unitHeightValue)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.group_add,
                color: Colors.white,
                size: 32 * unitHeightValue,

              ),
              tooltip: 'Add Groups',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupPage()));
              }, //will go to Create a group Page
            ),
            SizedBox(
              width: 10 * unitWidthValue,
            )
          ],
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ListGroupsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
