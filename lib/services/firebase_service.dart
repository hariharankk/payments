import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payment/services/Bloc.dart';
import 'package:payment/utility/jwt.dart';
import 'package:payment/models/store.dart';

class apirepository{
  late String Token;
  String uploadURL = 'http://152c-35-193-19-190.ngrok.io';
  JWT jwt = JWT();

  /// Add a map to a firestore collection
  Future<dynamic> store_getdata(String id) async{
    print(1);
    String URL = uploadURL+'/store/getdata/'+id;
    Token = await jwt.read_token();
    final response = await http.get(URL,
      headers: <String, String>{
        'x-access-token': Token
    },
    );
    try {
      var responseData = json.decode(response.body);
      if(responseData['status']){//array, alternative empty string ''
        List<dynamic> tempStore = [];
        tempStore = responseData['data'].map((snapshot) {
          Store store = Store.fromMap(snapshot);
          return store;
        }).toList();
      return tempStore;
      }
      else{
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }

  }

  Future<dynamic> store_uploaddata(Map<dynamic, dynamic> store) async {
    String URL = uploadURL + '/store/adddata';
    try {
      Token = await jwt.read_token();
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          'x-access-token': Token,
          "Accept": "application/json",
        },
        body: jsonEncode(store),
      );
      var responseData = json.decode(response.body);

      print(responseData['status']);//bool
      return responseData['Status'];
    } catch (e) {
      print(e);
      return false;
    }
  }
    Future<dynamic> employee_uploaddata(Map<dynamic, dynamic> emp) async {
      Token = await jwt.read_token();
      String URL = uploadURL + '/employee/adddata';
      try {
        final response = await http.post(
          Uri.parse(URL),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            'x-access-token': Token,
          },
          body: jsonEncode(emp),
        );
        var responseData = json.decode(response.body);
        print(responseData['status']);//bool
        return responseData['status'];
      } catch (e) {
        print(e);
        return false;
      }
    }
      Future<dynamic> employee_updatedata(String empid, String imageid) async{
        Token = await jwt.read_token();
        String URL = uploadURL+'/employee/update';
        try {
          final response = await http.post(
            Uri.parse(URL),
            headers: <String, String>{
              "Content-Type": "application/json",
              "Accept": "application/json",
              'x-access-token': Token,
            },
            body: jsonEncode(<String,String>{'empid':empid,'imageId':imageid}),
          );
          var responseData = json.decode(response.body);
          print(responseData['status']);
          return responseData['status'];//bool
        } catch (e) {
          print(e);
          return false;
        }
  }

  Future<dynamic> approval_delete(String empid) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/approval/delete/'+empid;
    final response = await http.get(URL,
      headers: <String, String>{
      'x-access-token': Token
    },
    );
    try {
      var responseData = json.decode(response.body);
      print(responseData['status']);//bool
      return responseData['status'];
    } catch (e) {
      print(e);
      return false;

    }

  }

  Future<dynamic> approval_adddata(Map<dynamic,dynamic> approval) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/approval/adddata';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'x-access-token': Token,
        },
        body: jsonEncode(approval),
      );
      var responseData = json.decode(response.body);
      print(responseData['status']);//bool
      return responseData['status'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> employee_getdata() async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/employee/getdata/'+userBloc.getUserObject().user;
    final response = await http.get(URL,
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    try {
      var responseData = json.decode(response.body);
      if(responseData['status']){//list, alternative empty string " "
        print(responseData['data']);
        return responseData['data'];}
      else{return [];}
    } catch (e) {
      print(e);
      return [];
    }

  }


  Future<dynamic> employeeadmin_getdata() async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/employeeadmin/getdata/'+userBloc.getUserObject().user;
    final response = await http.get(URL,
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    try {
      var responseData = json.decode(response.body);
      print((responseData['status']));
      if(responseData['status']){//list, alternative empty string " "
        print(responseData['data']);
        return responseData['data'];}
      else{return [];}
    } catch (e) {
      print(e);
      return [];
    }

  }


  Future<dynamic> history_getdata(String id) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/history/getdata/'+id;
    final response = await http.get(URL,
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    try {
      var responseData = json.decode(response.body);
      if(responseData['status']){//list, alternative empty string " "
        print(responseData['data']);
        return responseData['data'];}
      else{return [];}
    } catch (e) {
      print(e);
      return [];
    }

  }


  Future<dynamic> approval_getdata() async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/approval/getdata/'+userBloc.getUserObject().user;
    final response = await http.get(URL,
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    try {
      var responseData = json.decode(response.body);
      if(responseData['status']){//list, alternative empty string " "
        print(responseData['data']);
        return responseData['data'];}
      else{return [];}
    } catch (e) {
      print(e);
      return [];
    }

  }



  Future<dynamic> history_adddata(Map<String,dynamic> history) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/history/adddata';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'x-access-token': Token,
        },
        body: jsonEncode(history),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){//docref alternative empty string ' '
      return responseData['data'];}
      else{
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> history_updatedata(Map<String,dynamic> history) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/history/updatedata';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'x-access-token': Token,
        },
        body: jsonEncode(history),
      );
      var responseData = json.decode(response.body);
      print(responseData['status']);//bool
      return responseData['status'];
    } catch (e) {
      print(e);
      return false;
    }
  }

}
