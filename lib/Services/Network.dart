import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/Authenticate/Authenticate.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> getEventsFromServer() async {
  List list = [];

  final String url = 'https://pure-forest-54952.herokuapp.com/event/getEvents';

  var response = await http.get(url);

  if (response.statusCode == 200 || response.statusCode == 201) {
    list = json.decode(response.body);

    return list;
  } else {
    print("Error Status Code: ${response.statusCode}");
    return List();
  }
}

Future<List> getQuestionsListFromServer(String url) async {
  var response = await http.get(url);

  Map<String, dynamic> map;

  if (response.statusCode == 200 || response.statusCode == 201) {
    map = json.decode(response.body);

    print(map['results']);

    return map['results'];
  } else {
    print("Error Loading in Questions\n ${response.statusCode}");
    return List();
  }
}

Future<int> sendTokensAndTrohiestoServer(
    String username, Map<String, dynamic> map) async {
  String url = 'https://pure-forest-54952.herokuapp.com/user/tokens/$username';

  print(url);
  print(map);

  var response = await http.patch(
    url,
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Data Send Sucessfully");
    return response.statusCode;
  } else {
    print("Error in sending response statusCode : ${response.statusCode}");
    return response.statusCode;
  }
}

Future registerNewUser(Map<String, dynamic> map) async {
  final String url = 'https://pure-forest-54952.herokuapp.com/user/register';

  var response = await http.post(
    url,
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Register Sucessfully");
  } else {
    print("Error Occured");
  }
}

Future<String> userLogin(Map<String, String> map) async {
  final String _url = 'https://pure-forest-54952.herokuapp.com/user/login';

  var response = await http.post(
    _url,
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Login Sucessfully");
    return "Login Sucessfully";
  } else {
    print("Login Failed ${response.body}");
    return response.body;
  }
}

Future<Map<String, dynamic>> getUserDataFromServer(String username) async {
  final String _url = 'https://pure-forest-54952.herokuapp.com/user/$username';

  var _response = await http.get(_url);

  if (_response.statusCode == 200 || _response.statusCode == 201) {
    Map<String, dynamic> map = json.decode(_response.body);
    print(map);
    return map;
  } else {
    print("An Unexpected error occured StatusCode : ${_response.statusCode}");
    return Map<String, dynamic>();
  }
}

Future<List> getLeaderboardFromServer() async {
  final String _url = '';

  List _list = List();

  var _response = await http.get(_url);

  if (_response.statusCode == 200 || _response.statusCode == 201) {
    _list = json.decode(_response.body);

    return _list;
  } else {
    print("An Unexpected Error occured statusCode : ${_response.statusCode}");
    return List();
  }
}

Future logout(BuildContext context) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  await _prefs.clear().then((q) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Authenticate()),
        (Route<dynamic> route) => false);
  });
}
