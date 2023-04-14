import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'dart:async';
import 'package:payment/services/authentication.dart';
import 'package:payment/ui/admin_side/admin_page.dart';
import 'package:payment/ui/home_page.dart';
import 'package:payment/ui/admin or user.dart';
import 'package:payment/services/Bloc.dart';
import 'package:flutter/services.dart';
import 'package:payment/services/remainder.dart';
import 'package:payment/bloc/resources/injection.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
var frontCamera;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //cameras = await availableCameras();
  initGetIt();
  //NotificationService notificationService = NotificationService();
  //await notificationService.init();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
        title: 'payments',
            localizationsDelegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
        home: SplashScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
    });
  }
}


enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  // Set the timer duration for the splash screen
  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  // Navigate to root page after splash screen
  void navigationPage() {
    Get.to(()=> RootPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(color: Colors.black,),
        ),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

//TODO: Change the Auth state management to StreamBuilder

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool admin= false;

  BaseAuth auth = Auth();
  @override
  void initState() {
    super.initState();
    userBloc.currentuser().then((_) {
      setState(() {
        if (userBloc.getUserObject() != null) {
          _userId = userBloc.getUserObject().username!;
          authStatus = AuthStatus.LOGGED_IN;
          admin = userBloc.getUserObject().admin!;

        }
        else{authStatus = AuthStatus.NOT_LOGGED_IN;}
      });
    });
  }


  void loginCallback() {
    auth.getCurrentUser().then((user) {
      setState(() {
        _userId = userBloc.getUserObject().username!;
        admin = userBloc.getUserObject().admin!;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }
  // Logout Callback
  Future<void> logoutCallback() async {
    await auth.signOut();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      admin=false;
    });
  }

  // Waiting Screen Widget
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return  //LoginPage(
          UserorAdmin(
            loginCallback: loginCallback,
          );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          print(admin);
          if (admin) {
            return  AdminPage(
              logoutCallback: logoutCallback,
            );
          } else {
            // Employee
            return  HomePage(
              logoutCallback: logoutCallback,
            );
          }
        }else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}



