import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payment/utility/jwt.dart';
import 'package:payment/models/user.dart';

abstract class BaseAuth {
  Future<dynamic> signUp(Map<String,dynamic> user);

  Future<dynamic> getCurrentUser();

  Future<dynamic> signOut();

  Future<dynamic> sendotp(String phone);

  Future<dynamic> signInWithOTP(String phone, String verificationId);

  Future<dynamic> signInWithEmail(String email, String password);
}

class Auth implements BaseAuth {
  late String Token;
  String uploadURL = 'http://3312-34-83-113-5.ngrok.io';
  JWT jwt= JWT();


  Future<dynamic> signUp(Map<dynamic,dynamic> user) async{
    String URL = uploadURL+'/register/';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(user),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
      print(responseData["data"]);
      return User.fromMap(responseData["data"]);
      }
      else{
        return '';
      }
    } catch (e) {
      print(e);
       return '';
    }
  }

  Future<dynamic> getCurrentUser() async {
    Token = await jwt.read_token();
    if(Token == null){
      return null;
    }
    String URL = uploadURL+'/currentuser';
    final response = await http.get(Uri.parse(URL),
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    //try {
      print(response.body);
      var responseData = json.decode(response.body);
      User user = User.fromMap(responseData);//list, alternative empty string " "
      return user;
    } //catch (e) {
      //print(e);
      //return null;
    //}
  //}

  Future<void> signOut() async {
    await jwt.delete_token();
  }


  Future<dynamic> signInWithEmail(String email, String password) async{
    String URL = uploadURL+'/login';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String,String>{'email':email,'password':password}),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        await jwt.store_token(responseData['token']);
        return User.fromMap(responseData["data"]);
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> signInWithOTP(String phone, String verificationId) async{
    String URL = uploadURL+'/register/';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String,String>{'phonenumber':phone,'verification-code':verificationId}),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        await jwt.store_token(responseData['token']);
        return User.fromMap(responseData["data"]);
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> sendotp(String phone) async{
    String URL = uploadURL+'/getOTP';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String,String>{'phonenumber':phone}),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        return responseData['code'];
      }
      else{
        return '';
      }
    } catch (e) {
      return '';
    }
  }



}
