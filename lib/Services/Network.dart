import 'dart:convert';

import 'package:http/http.dart' as http;

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

Future sendTokensAndTrohiestoServer(
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
  } else {
    print("Error in sending response statusCode : ${response.statusCode}");
  }
}

Future registerNewUser(Map<String, dynamic> map) async {
  final String url = '';

  var response = await http.post(
    url,
    body: map,
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
