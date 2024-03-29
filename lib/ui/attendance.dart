import 'dart:io';
import 'package:payment/models/history.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/services/location_service.dart';
import 'package:payment/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payment/widgets/cameras.dart';
import 'package:payment/services/Bloc.dart';

class MarkAttendancePage extends StatefulWidget {
  @override
  _MarkAttendancePageState createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage>
    with AutomaticKeepAliveClientMixin<MarkAttendancePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  File? _image; // Store the image
  apirepository Apirepository = apirepository();


  String msgFace = ""; // [Verify Face], [Success], [Retry]
  String subFace = "";
  bool _statusFace = false;

  String msgLocation = ""; // [Verify Face], [Success], [Retry]
  String subLoc = "";
  bool _statusLocation = false;

  DateTime? checkInTime; // Store the check In Time
  DateTime? checkOutTime; // Store the check out Time

  String? _docRef;

  int _currentStep = 0; // Store the index of current step

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Load Data from Local Storage
  _initialize() async {
    SharedPreferences prefs = await _prefs;

    bool statusFace = prefs.getBool('statusFace') ?? false;
    bool statusLocation = prefs.getBool('statusLocation') ?? false;

    int currentStep = prefs.getInt("currentStep") ?? 0;
    String?  chkIn = prefs.getString("checkInTime") ?? null;
    String? docRef = prefs.getString("docRef") ?? null;


    if (statusFace && statusLocation) {
      currentStep = 0;
    } else {
      statusFace = false;
      statusLocation = false;
      currentStep = 0;
      docRef = null;
    }

    setState(() {
      _image = null;
      _statusFace = statusFace;
      _statusLocation = statusLocation;
      _currentStep = currentStep;
      _docRef = docRef;
      subFace = "Verify Face";
      subLoc = "Verify Location";
      msgFace = "Verify Face";
      msgLocation = "Verify Location";
    });

    if (chkIn != null)
      setState(() {
        checkInTime = DateTime.parse(chkIn);
      });
  }


  /// Recognize face and return wether it matches or not
  Future<void> verifyFace(BuildContext context) async {
    setState(() {
      subFace = "Verifying...";
    });

    Imagestorage imagestorage = Imagestorage();
    final image = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen()));
    _image = File(image.path);
    if (_image == null) {
      setState(() {
        msgFace = "Verify Face";
        subFace = "Verify Face";
      });
      return;
    }
    var statusFace = await imagestorage.check_attendance(_image!, userBloc.getUserObject().user);
    setState(() {
      _statusFace = statusFace;
      msgFace = statusFace ? "Verified" : "Face not verified. Retry!";
      subFace = statusFace ? "Verified" : "Face not verified. Retry!";
    });
  }

  /// Verify Location
  Future<void> verifyLocation() async {
    setState(() {
      subLoc = "Verifying...";
    });

    var data = await Apirepository.employee_getdata();
    double storeLat = double.parse(data['lat']);
    double storeLong = double.parse(data['longi']);
    double storeRadius = double.parse(data['radius'].toString());

    LocationService locationService =  LocationService();
    var position = await Geolocator.getCurrentPosition();
    if (position == null) return;

    bool statusLocation = locationService.getDistance(position.latitude,
        position.longitude, storeLat, storeLong, storeRadius);

    setState(() {
      _statusLocation = statusLocation;
      msgLocation = statusLocation ? "Verified" : "Location not Verified. Retry!";
      subLoc = statusLocation ? "Verified" : "Location not Verified. Retry!";
    });

    if (_statusFace && statusLocation) {
      await checkIn();
    }
  }

  // Check In
  checkIn() async {

    DateTime _checkInTime = DateTime.now();
    setState(() {
      checkInTime = _checkInTime;
    });

    History history = History(
        userId: userBloc.getUserObject().user,
        checkIn: _checkInTime.toString(),
        checkOut: "-",
        hrsSpent: "0");

    Map<dynamic, dynamic> map = history.toMap();

    var docRef = await Apirepository.history_adddata(map);

    setState(() {
      _docRef = docRef;
    });

    SharedPreferences prefs = await _prefs;
    prefs.setBool("statusFace", _statusFace);
    prefs.setBool("statusLocation", _statusLocation);
    prefs.setInt("currentStep", _currentStep);
    prefs.setString("docRef", _docRef!);
    prefs.setString("checkInTime", _checkInTime.toString());
  }

  // Check Out
  checkOut() async {
    SharedPreferences prefs = await _prefs;
    DateTime _checkOutTime = DateTime.now();

    setState(() {
      checkOutTime = _checkOutTime;
    });

    checkInTime = DateTime.parse(prefs.getString("checkInTime")!);
    Duration diff = checkOutTime!.difference(checkInTime!);
    int hrsSpent = diff.inHours;

    History history = History(
      userId: userBloc.getUserObject().user,
      checkIn: checkInTime.toString(),
      checkOut: checkOutTime.toString(),
      hrsSpent: hrsSpent.toString(),
      randomint : _docRef,
    );

    Map<dynamic, dynamic> map = history.toMap();

    await Apirepository.history_updatedata(map);

    setState(() {
      _statusFace = false;
      _statusLocation = false;
      _currentStep = 0;
      msgFace = "Verify Face";
      msgLocation = "VerifyLocation";
      subFace = "Verify Face";
      subLoc = "Verify Location";
    });

    prefs.setBool("statusFace", false);
    prefs.setBool("statusLocation", false);
    prefs.setInt("currentStep", 0);
    prefs.remove("docRef");

  }

  /// Define what will happen on clicking on continue
  next() {
    if (_currentStep == 0 && _statusFace) {
      setState(() {
        _currentStep += 1;
      });
    }
    if (_currentStep == 1 && _statusLocation && _statusFace) {
      checkIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _statusFace && _statusLocation
          ? Center(
        child: MaterialButton(
          padding: EdgeInsets.all(15.0),
          textColor: Colors.white,
          onPressed: checkOut,
          child: Text(
            "Check Out",
            textScaleFactor: 1.3,
          ),
          color: Colors.red,
        ),
      )
          : Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: ListView(
          // margin: EdgeInsets.only(top: 10.0),
          children: [
            Stepper(
              onStepContinue: next,
              type: StepperType.vertical,
              currentStep: _currentStep,
              steps: <Step>[
                Step(
                  title: Text(
                    "Face Verification",
                    textScaleFactor: 1.3,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Text(
                        subFace,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: subFace == "Verified"
                              ? Colors.green
                              : subFace == "Verify Face"
                              ? Colors.grey
                              : subFace == "Verifying..."
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                      subFace == "Verifying..."
                          ? CircularProgressIndicator()
                          : Center(),
                    ],
                  ),
                  content: MaterialButton(
                    padding: EdgeInsets.all(13.0),
                    onPressed:
                    subFace == "Verifying..." ? null : ()async{await verifyFace(context);},
                    textColor: Colors.white,
                    child: Text(
                      "Verify Face",
                      textScaleFactor: 1.1,
                    ),
                    color: msgFace == "Verified"
                        ? Colors.green
                        : Colors.orange,
                  ),
                  isActive: (_currentStep == 0),
                ),
                Step(
                  title: Text(
                    "Location Verification",
                    textScaleFactor: 1.3,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Text(
                        subLoc,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: subLoc == "Verified"
                              ? Colors.green
                              : subLoc == "Verify Location"
                              ? Colors.grey
                              : subLoc == "Verifying..."
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                      subLoc == "Verifying..."
                          ? CircularProgressIndicator()
                          : Center(),
                    ],
                  ),
                  content: MaterialButton(
                    padding: EdgeInsets.all(13.0),
                    onPressed:
                    subLoc == "Verifying..." ? null : verifyLocation,
                    textColor: Colors.white,
                    child: Text(
                      "Verify Location",
                      textScaleFactor: 1.1,
                    ),
                    color: subLoc == "Verified"
                        ? Colors.green
                        : Colors.orange,
                  ),
                  isActive: (_currentStep == 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Define if we want ot keep the state of the page alive
  @override
  bool get wantKeepAlive => true;
}