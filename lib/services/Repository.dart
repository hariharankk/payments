import 'dart:async';
import 'package:payment/models/user.dart';
import 'package:payment/services/authentication.dart';

class Repository {
  final apiProvider = Auth();

  Future<dynamic> registerUser(Map<dynamic,dynamic> user) =>
      apiProvider.signUp(user);

  Future signinUser(String email, String password) =>
      apiProvider.signInWithEmail(email, password);

  Future phonesigninUser(String phone, String verificationId) =>
      apiProvider.signInWithOTP(phone, verificationId);

  Future currentuser() =>
      apiProvider.getCurrentUser();

}

final repository = Repository();