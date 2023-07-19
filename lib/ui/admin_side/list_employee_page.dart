import 'package:payment/models/employee.dart';
import 'package:payment/models/store.dart';
import 'package:payment/ui/admin_side/attendance history.dart';
import 'package:flutter/material.dart';
import 'package:payment/services/exit socket.dart';
import 'package:payment/services/history socket exit.dart';
import 'package:payment/services/Bloc.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:payment/global.dart';
import 'package:get/get.dart';
import 'package:payment/Screen/Payments_frontscreen.dart';
import 'package:payment/ui/admin_side/calendar.dart';

class ListEmployeePage extends StatefulWidget {

  @override
  _ListEmployeePageState createState() => _ListEmployeePageState();
}

class _ListEmployeePageState extends State<ListEmployeePage> {
  Map<String, String> storeNames = {};

  bool loading = false;
  HistoryExitSocket history = HistoryExitSocket();

  @override
  void initState() {
    empadminBloc.employeeadmin_getdata();
    _initStoreName();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  /// Map [store.id] to [store.name] and save it
  _initStoreName() async {
    Map<String, String> map = {};
    for (Store store in storeBloc.getUserObject()) {
      map[store.id] = store.name;
    }
    setState(() {
      storeNames = map;
    });
  }

  /// Build Drop Down Menu Item

  /// Build a list of employees
  List<Widget> _buildList(
      BuildContext context, List<dynamic> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  /// Build list item (employee)
  Widget _buildListItem(BuildContext context, Map<dynamic,dynamic> data) {
    Employee emp = Employee.fromMap(data);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () async{
          Get.to(()=>AttendanceHistory(userId: emp.id,));
          history.Stopthread();
          },
        leading: CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Center(
              child: emp.image == ''
            ? Container(
            color: Colors.blue,
              child: Center(
                child: Text(
                  "Add Image",
                  textScaleFactor: 0.5,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                ),
              ),
            )
                :Image.network(
                emp.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
        title: Text(
          "${emp.first} ${emp.last}",
          textScaleFactor: 1.2,
        ),
        subtitle: Text(
          "Store: ${storeNames[emp.storeID]}",
          textScaleFactor: 1.1,
        ),
        trailing: Icon(Icons.chevron_right, size: 40.0),
      ),
    );
  }

  List<Widget> _buildList1(
      BuildContext context, List<dynamic> snapshot) {
    return snapshot.map((data) => _buildListItem1(context, data)).toList();
  }

  /// Build list item (employee)
  Widget _buildListItem1(BuildContext context, Map<dynamic,dynamic> data) {
    Employee emp = Employee.fromMap(data);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () async{
          Get.to(()=>payments(empid: emp.id,empname:emp.first ,));
          history.Stopthread();
        },
        leading: CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Center(
              child: emp.image == ''
                  ? Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Add Image",
                    textScaleFactor: 0.5,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                  ),
                ),
              )
                  :Image.network(
                emp.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
        title: Text(
          "${emp.first} ${emp.last}",
          textScaleFactor: 1.2,
        ),
        subtitle: Text(
          "Store: ${storeNames[emp.storeID]}",
          textScaleFactor: 1.1,
        ),
        trailing: Icon(Icons.chevron_right, size: 40.0),
      ),
    );
  }


  List<Widget> _buildList2(
      BuildContext context, List<dynamic> snapshot) {
    return snapshot.map((data) => _buildListItem2(context, data)).toList();
  }

  /// Build list item (employee)
  Widget _buildListItem2(BuildContext context, Map<dynamic,dynamic> data) {
    Employee emp = Employee.fromMap(data);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () async{
          Get.to(()=>employeeCalendar(userid: emp.id));
          history.Stopthread();
        },
        leading: CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Center(
              child: emp.image == ''
                  ? Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Add Image",
                    textScaleFactor: 0.5,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                  ),
                ),
              )
                  :Image.network(
                emp.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
        title: Text(
          "${emp.first} ${emp.last}",
          textScaleFactor: 1.2,
        ),
        subtitle: Text(
          "Store: ${storeNames[emp.storeID]}",
          textScaleFactor: 1.1,
        ),
        trailing: Icon(Icons.chevron_right, size: 40.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            isScrollable: true,
            tabs: employeetabs,
            indicatorColor: Colors.white,
          ),
        ),
        body:
            StreamBuilder(
            stream:
            empadminBloc.getempadmin,
              builder: (context,  AsyncSnapshot snapshot) {

          if (snapshot == null && snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }


                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

              if (snapshot.data == null || snapshot.data!.length == 0) {
                  return Center(
                    child: Text(
                      "No Employees Found!",
                      textScaleFactor: 1.3,
                      maxLines: 2,
                    ),
                  );
                }

      List<Widget> _empList = _buildList(context, snapshot.data!);
      List<Widget> _empList1 = _buildList1(context, snapshot.data!);
      List<Widget> _empList2 = _buildList2(context, snapshot.data!);

    return
      TabBarView(
        children: [
          SingleChildScrollView(
            child:Container(
                margin: EdgeInsets.all(15.0),
                child:
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _empList[index],
                  itemCount: _empList.length,
                ),
                ),
        ),
          SingleChildScrollView(
            child:Container(
              margin: EdgeInsets.all(15.0),
              child:
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => _empList1[index],
                itemCount: _empList1.length,
              ),
            ),
          ),
          SingleChildScrollView(
            child:Container(
              margin: EdgeInsets.all(15.0),
              child:
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => _empList2[index],
                itemCount: _empList2.length,
              ),
            ),
          ),


        ]
      );
      }),



      ),
    );
    }
  }