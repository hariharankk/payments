
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:payment/loc/loc.dart';
import 'package:payment/constants.dart';
import 'package:intl/intl.dart';

class ApiProvider {
  Client client = Client();

  Future<List> getLocation(String userid) async {
    final queryParameters = {'userid':userid};
    String Locationget = uploadURL+ '/api/location-get';
    List<loc> locs = [];
    final response = await client.get(
      Uri.parse(Locationget).replace( queryParameters: queryParameters),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    final Map result = json.decode(response.body);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      for (Map<String, dynamic> json_ in result["data"]) {
        print(json_);
        try {
          loc Loc = loc.fromJson(json_);
          locs.add(Loc);
        } catch (Exception) {
          print(Exception);
        }
      }
      return locs;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }

    }

  /// Add a Group
  Future addloc(Map<dynamic,dynamic> data) async {
    String Locposturl = uploadURL + '/api/location-add';

    final response = await client.post(
      Uri.parse(Locposturl),
      headers: {
         "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final Map result = json.decode(response.body);
      print(DateFormat.jm().format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(result['data']['time'])),)));
      loc Loc = loc.fromJson(result["data"]);
      //print("Group: " + addedGroup.name + " added");
      return Loc;
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }
}