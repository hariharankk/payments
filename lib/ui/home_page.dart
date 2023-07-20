import 'package:payment/ui/common/attendance_history.dart';
import 'package:payment/ui/Opening page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:payment/ui/schedule.dart';
import 'package:payment/ui/todo/pages/home_page.dart';
import 'package:payment/ui/Ledger Home.dart';
import 'package:payment/services/firebase_storage_service.dart';
import 'package:payment/services/Bloc.dart';
import 'package:payment/ui/Settings.dart';
import 'package:get/get.dart';
import 'package:payment/ui/attendance.dart';
import 'dart:async';
import 'package:payment/loc/loc.dart';
import 'package:location/location.dart' as loci;
import 'package:payment/loc/repository.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  final VoidCallback logoutCallback;


  HomePage({required this.logoutCallback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List appBarTitle = ['Mark Attendance', 'Attendance History', 'Ledger', 'Chat', 'Calendar'];
  int _currentIndex = 0;
  late PageController _pageController;
  late bool Status = false;
  bool loading = true;
  final loci.Location location = loci.Location();
  StreamSubscription<loci.LocationData>? _locationSubscription;
  final repository = Repository();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    _requestPermission();
    _pageController = PageController();
    _imagestatus();
  }


  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loci.LocationData currentlocation) async {
      try {
        final loc Loc = loc(longi: currentlocation.longitude.toString(),
            lat: currentlocation.latitude.toString(),
            userid: userBloc.getUserObject().user ,time: DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(DateTime.now()));
        Map<dynamic, dynamic> locmap = Loc.toMap();
        repository.addloc(locmap);
      }catch(e){
        print(e);
      }
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    _locationSubscription = null;

  }

  void _requestPermission() async {
    loci.PermissionStatus _permissionGranted;

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loci.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loci.PermissionStatus.granted) {
        return;
      }
    }
    location.changeSettings(interval: 100000, accuracy: loci.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    _listenLocation(); // start listening only after permissions are granted
  }

  void _imagestatus() async{
   Imagestorage imagestorage = Imagestorage();
    bool status = await imagestorage.getstatus(userBloc.getUserObject().user);
    setState(() {
      Status = status;
      loading = false;
    });
  }

  @override
  void dispose() {
    _stopListening();
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return loading?
     SafeArea(
       child: Scaffold(
          appBar: AppBar(
            title: Text('Wait for a second'),
          ),
        body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            Text(
              "Loading... , please wait",
              textScaleFactor: 1.1,
            ),
          ],
        ),
    ),
    ),
     )
        :!Status ? OpeningPage(logoutCallback: widget.logoutCallback,)

        :Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle[_currentIndex]),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Get.to(()=>SettingsPage(logoutCallback: widget.logoutCallback));
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: widget.logoutCallback,
            icon: Icon(Icons.exit_to_app),
          ),

        ],
        automaticallyImplyLeading: false,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[

          MarkAttendancePage(),
          AttendanceHistory(),
          Ledger(),
          Groups(),
          clientemployeeCalendar()
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text("Home"),
            icon: Icon(Icons.home),
            activeColor: Colors.orange,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("History"),
            icon: Icon(Icons.history),
            activeColor: Colors.purpleAccent,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("Ledger"),
            icon: Icon(Icons.book),
            activeColor: Colors.blue,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("Chat"),
            icon: Icon(Icons.chat),
            activeColor: Colors.pink,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("Calendar"),
            icon: Icon(Icons.calendar_month),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),

        ],
      ),
    );
  }
}
