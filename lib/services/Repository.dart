import 'dart:async';
import 'package:payment/models/user.dart';
import 'package:payment/services/authentication.dart';
import 'package:payment/services/firebase_service.dart';

class Repository {
  final apiProvider =  Auth();
  final apiProvider1 = apirepository();

  Future<dynamic> registerUser(Map<dynamic,dynamic> user) =>
      apiProvider.signUp(user);

  Future signinUser(String email, String password) =>
      apiProvider.signInWithEmail(email, password);

  Future phonesigninUser(String phone, String verificationId) =>
      apiProvider.signInWithOTP(phone, verificationId);

  Future currentuser() =>
      apiProvider.getCurrentUser();

  Future store_getdata(String id) =>
      apiProvider1.store_getdata(id);

  Future  addStore(Map<dynamic, dynamic> store) =>
      apiProvider1.store_uploaddata(store);


}

final repository = Repository();