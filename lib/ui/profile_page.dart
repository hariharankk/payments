import 'dart:io';
import 'package:payment/widgets/listtile.dart';
import 'package:payment/models/approval.dart';
import 'package:payment/models/employee.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:payment/services/history socket exit.dart';
import 'package:payment/constants.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // scaffold key
  late File image;
  bool requestChange = false;
  HistoryExitSocket hist = HistoryExitSocket();

  @override
  void initState() {
    super.initState();
    hist.Stopthread();
    empadminBloc.employee_getdata();
  }

  void dispose() {
    print('dispose page one');
    super.dispose();

  }

  //TODO: Change the Approval Process to include other changes as well
  //TODO: Create a form to change all the fields...can be null...change only what is needed 

  /// Send the image for approval
  _changeImage(Employee emp) async {
    //Choose Image First
    await _chooseImage();

    if (image == null) return; // Cancelled image change

    // Set [requestChange] to true
    setState(() {
      requestChange = true;
    });

    apirepository Apirepository = apirepository();
    Imagestorage imagestorage = Imagestorage();

    showInSnackBar("Uploading Image for Approval....", Duration(seconds: 3));

    //upload image to firebase storage
    String img = await imagestorage.upload(image);

    if (img == null || img == "")
    {
      showInSnackBar(
          "not able to recognise the face retry", Duration(seconds: 2));
      setState(() {
        requestChange = false;
      });
      return;
    }

    String imgURL = uploadURL+'/image/'+img;

    String name = emp.first + " " + emp.last;
    Approval approval =
    new Approval(empId: emp.id, empName: name, imageId: imgURL);
    Map<dynamic, dynamic> map = approval.toMap();

    //upload to firebase collection [approval]
    await Apirepository.approval_adddata(map);

    // Display success message on screen
    showInSnackBar(
        "Sent Image for approval successfully", Duration(seconds: 2));

    setState(() {
      requestChange = false;
    });
  }

  /// Choose imAge from front camera
  _chooseImage() async {
    final _picker = ImagePicker();
    var img = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      image = File(img!.path);
    });
  }

  /// Display message in snack bar
  void showInSnackBar(String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: StreamBuilder(
        stream:  empadminBloc.getemp,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          Employee emp = Employee.fromMap(snapshot.data);


          return requestChange
              ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20.0),
                Text(
                  "Sending request for changes...",
                  textScaleFactor: 1.1,
                ),
              ],
            ),
          )
              : ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () => _changeImage(emp),
                    child: CircleAvatar(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          ClipOval(
                            child: Center(
                              child: emp.imageId == null
                                  ? Container(
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    "Add Image",
                                    textScaleFactor: 1.1,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              )
                                  : Image.network(
                                emp.image,
                                width: 700,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent?
                                    loadingProgress) {
                                  if (loadingProgress == null)
                                    return child;
                                  return CircularProgressIndicator(
                                    backgroundColor:
                                    Colors.white,
                                    value: loadingProgress
                                        .expectedTotalBytes !=
                                        null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        loadingProgress
                                            .expectedTotalBytes!
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ),
                          CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.edit,
                                  size: 25.0, color: Colors.white)),
                        ],
                      ),
                      radius: 80.0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30,),

              listtile(
                subtitle: "Name",
                icon: Icon(Icons.person, color: Colors.black),
                text: emp.first + emp.last,
              ),

              listtile(
                subtitle: "Email Id",
                icon: Icon(Icons.mail, color: Colors.black),
                text: emp.email,
              ),

              listtile(
                subtitle: "phone number",
                icon: Icon(Icons.phone, color: Colors.black),
                text: emp.phone,
              ),

              listtile(
                subtitle: "Experience",
                text: emp.exp == "1"
                    ? emp.exp + " year"
                    : emp.exp + " years",
                icon: Icon(Icons.work, color: Colors.black),
              ),

              listtile(
                text: emp.specialization!,
                subtitle: "Expertise",
                icon: Icon(Icons.gpp_good_outlined, color: Colors.black),
              ),

              listtile(
                text: emp.addr,
                subtitle: "address",
                icon: Icon(Icons.location_city_sharp, color: Colors.black),
              ),

              listtile(
                text: emp.aadhar,
                subtitle: "Aadhar Card Number",
                icon: Icon(Icons.credit_card, color: Colors.black,),
              ),

            ],
          );
        },
      ),
    );
  }

/// Adds a constant space between two widgets
}
