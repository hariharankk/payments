import 'package:payment/ui/common/attendance_history.dart';
import 'package:payment/ui/help_page.dart';
import 'package:payment/ui/profile_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  final VoidCallback logoutCallback;
  final String userId;

  HomePage({required this.logoutCallback, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List appBarTitle = ['Mark Attendance', 'Attendance History', 'My Profile', 'Help'];
  int _currentIndex = 0;
  late PageController _pageController;
  late bool Status;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController();
    //_imagestatus();
  }

 // void _imagestatus() async{
 //   Imagestorage imagestorage = Imagestorage();
 //   bool status = await imagestorage.getstatus(widget.userId);
 //   setState(() {
 //     Status = status;
  //    loading = false;
 //   });
  //}

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
    :Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle[_currentIndex]),
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
            userId: widget.userId,
          ),
          ProfilePage(
            userId: widget.userId,
            logoutCallback: widget.logoutCallback,
          ),
          HelpPage(),
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
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("History"),
            icon: Icon(Icons.history),
            activeColor: Colors.purpleAccent,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("Profile"),
            icon: Icon(Icons.person),
            activeColor: Colors.pink,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text("Help"),
            icon: Icon(Icons.help),
            activeColor: Colors.blue,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
