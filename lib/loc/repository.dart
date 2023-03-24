import 'dart:async';
import 'package:payment/loc/APi.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<List> getLocation(String userid) => apiProvider.getLocation(userid);
  Future addloc(Map<dynamic,dynamic> data) => apiProvider.addloc(data);

}

final repository = Repository();
