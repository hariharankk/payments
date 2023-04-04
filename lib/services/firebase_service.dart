import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payment/services/Bloc.dart';
import 'package:payment/utility/jwt.dart';
import 'package:payment/models/store.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/models/Shifts.dart';

class apirepository{
  late String Token;
  String uploadURL = 'http://e0ce-35-204-243-37.ngrok.io';
  JWT jwt = JWT();

  /// Add a map to a firestore collection
  Future<dynamic> store_getdata(String id) async{
    String URL = uploadURL+'/store/getdata/'+id;
    Token = await jwt.read_token();
    final response = await http.get(Uri.parse(URL),
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
    final response = await http.get(Uri.parse(URL),
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
    final response = await http.get(Uri.parse(URL),
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
    final response = await http.get(Uri.parse(URL),
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
    final response = await http.get(Uri.parse(URL),
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
    final response = await http.get(Uri.parse(URL),
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


  Future getPayments(String range, String category ,String userid) async {
    final Token = await jwt.read_token();
    List data;
    final queryParameters = {
      "category": category,
      "userid": userid,
      "range": range,
    };
    Uri getPaymentsURL = Uri.parse(uploadURL+'/api/payments-get').replace(queryParameters: queryParameters);
    List<Payments> payments = [];
    try {
      final response = await http.get(
        getPaymentsURL,
        headers: {
          'x-access-token': Token,
        },
      );

      final Map result = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        if (result["data"].length > 0) {
          for (Map<String, dynamic> json_ in result["data"]) {
            Payments payment = Payments.fromJson(json_);
            payments.add(payment);
          }
          data = [payments, result["total"]];
          return data;
        }else
          print('waste');
          return [];
      }
    }catch (e) {
      print(e);
      return [];
    }
  }


  Future getLedgerdata(String range ,String userid) async {
    final Token = await jwt.read_token();
    List data;
    final queryParameters = {
      "userid": userid,
      "range": range,
    };
    Uri getPaymentsURL = Uri.parse(uploadURL+'/api/ledgerdata-get').replace(queryParameters: queryParameters);
    List<Payments> payments = [];
    try {
      final response = await http.get(
        getPaymentsURL,
        headers: {
          'x-access-token': Token,
        },
      );
      final Map result = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        if (result["data"].length > 0) {
          for (Map<String, dynamic> json_ in result["data"]) {
            Payments payment = Payments.fromJson(json_);
            payments.add(payment);
          }
          data = [payments, result["total_credit"],result["total_debit"],result["Balance"],];
          return data;
        }else
          return null;
      }
    }catch (e) {
      print(e);

      return null;
    }
  }


  Future<dynamic> Payments_adddata(Map<dynamic,dynamic> payments) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/api/payments-add';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'x-access-token': Token,
        },
        body: jsonEncode(payments),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        return responseData['status'];}
      else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> payments_delete(String payments) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/api/payments_delete/'+payments;
    final response = await http.get(Uri.parse(URL),
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

  Future getShifts(String userid) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      "userid": userid,
    };
    Uri getPaymentsURL = Uri.parse(uploadURL+'/api/shift-get').replace(queryParameters: queryParameters);
    List data;
    try {
      final response = await http.get(
        getPaymentsURL,
        headers: {
          'x-access-token': Token,
        },
      );

      final Map result = json.decode(response.body);
      if (response.statusCode == 200) {
        data = [result["nightshift"],result["morningshift"],result["leaveshift"],];
        return data;
        }else{

        return null;
      }
    }catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> Shifts_adddata(DateTime date, String type_of_shift ,String userid) async{
    Token = await jwt.read_token();
    String URL = uploadURL+'/api/Shift-add';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'x-access-token': Token,
        },
        body: jsonEncode({
        "type_of_shift": type_of_shift,
        "userid": userid,
        "date": date.toString(),
        }),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        return responseData['status'];}
      else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }




}
