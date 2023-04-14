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

class HomePage extends StatefulWidget {
  final VoidCallback logoutCallback;


  HomePage({required this.logoutCallback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List appBarTitle = ['Mark Attendance', 'Attendance History', 'My Profile', 'Help'];
  int _currentIndex = 0;
  late PageController _pageController;
  late bool Status = true;
  bool loading = false;//true;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController();
    //_imagestatus();
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

          AttendanceHistory(
          ),

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
