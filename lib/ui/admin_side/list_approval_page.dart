import 'package:payment/models/approval.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:payment/services/exit socket.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:payment/global.dart';
import 'package:payment/ui/admin_side/Leave.dart';



class approval extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: TabBar(
          isScrollable: true,
          tabs: approvaltabs,
          indicatorColor: Colors.white,
        ),
      ),
      body:     TabBarView(
          children: [
            ListApprovalPage(),
            LeaveRequestWidget()
          ]
          )
      ),
    );
  }
}





class ListApprovalPage extends StatefulWidget {

  @override
  _ListApprovalPageState createState() => _ListApprovalPageState();
}

class _ListApprovalPageState extends State<ListApprovalPage> {
  /// Build List of Approvals
  //StreamSocket streamSocket =StreamSocket();
//  ApprovalExitSocket streamsSocket = ApprovalExitSocket();

  void initState() {
    super.initState();
    print('init');
    approvalBloc.approval_getdata();
    //streamSocket.openingapprovalconnectAndListen(userBloc.getUserObject().user);
  }


  void dispose() {
    super.dispose();
    print('dispose approval');
    //streamsSocket.Stopthread();
  }

  _buildList(List<dynamic> snapshots) {
    return snapshots.map((snapshot) => _buildListItem(snapshot)).toList();
  }

  /// Build a List Item
  _buildListItem(Map<dynamic,dynamic> snapshot) {
    Approval approval = Approval.fromMap(snapshot);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageApprovalPage(approval: approval))),
        leading: CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Center(
              child: Image.network(
                approval.imageId!,
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
          "${approval.empName}",
          textScaleFactor: 1.2,
        ),
        trailing: Icon(Icons.chevron_right, size: 40.0),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: approvalBloc.getapproval,//streamSocket.getResponse,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null || snapshot.data!.length == 0) {
              return Center(
                child: Text(
                  "No Approvals Found!",
                  textScaleFactor: 1.3,
                  maxLines: 2,
                ),
              );
            }


            var _approvalList = _buildList(snapshot.data!);

            return ListView.builder(
              itemCount: _approvalList.length,
              itemBuilder: (context, index) => _approvalList[index],
            );
          }),
    );
  }
}

class ImageApprovalPage extends StatefulWidget {
  final Approval approval;

  ImageApprovalPage({required this.approval});

  @override
  _ImageApprovalPageState createState() => _ImageApprovalPageState();
}

class _ImageApprovalPageState extends State<ImageApprovalPage> {
  late bool _isWorking;
  apirepository Apirepository = apirepository();


  /// Add Image to the user database when approved
  _onApprove() async {
    // Set working to true
    _toggleWorking();

    // add the [imageId] in the user database

    Apirepository.employee_updatedata(widget.approval.empId!, widget.approval.imageId!);


    // remove this from the list of approvals
    await _deleteEntry();
  }

  /// Delete this entry and the image from the firebase storage
  _onDeny() async {
    _toggleWorking();

    //Remove image from firebase storage
    Imagestorage imagestorage = Imagestorage();
    await imagestorage.deleteFile(widget.approval.imageId!);

    //Remove this from the list of approvals
    await _deleteEntry();
  }

  /// Delete this entry from firebase
  _deleteEntry() async {

    // Delete Entry from list of approvals
    await Apirepository.approval_delete(widget.approval.empId!);

    approvalBloc.approval_getdata();

    //toggle working state and pop back
    _toggleWorking();
    Navigator.of(context).pop();
  }

  /// Toggle Circular Progress Indicator
  _toggleWorking() {
    setState(() {
      _isWorking = !_isWorking;
    });
  }

  @override
  void initState() {
    super.initState();
    _isWorking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approve Image"),
      ),
      body: _isWorking
          ? Center(
              child: ListView(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 12.0),
                  Center(
                    child: Text(
                      "Processing...",
                      textScaleFactor: 1.3,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                  child: Image.network(
                    widget.approval.imageId!,
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.height * 0.40,
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
                SizedBox(height: 20.0),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        padding: EdgeInsets.all(12.0),
                        onPressed: _onApprove,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "APPROVE",
                          textScaleFactor: 1.3,
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(12.0),
                        onPressed: _onDeny,
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text(
                          "DENY",
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
