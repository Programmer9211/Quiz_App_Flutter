import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Loading.dart';

import 'WelcomePage.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String username;
  bool isnull;

  @override
  void initState() {
    check();
    super.initState();
  }

  void check() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance().then((l) {
      setState(() {
        isnull = false;
      });

      return l;
    });

    setState(() {
      username = _prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isnull == null) {
      return Loading();
    } else if (isnull == false) {
      if (username == null) {
        return WelcomeScreen();
      } else {
        return HomePage();
      }
    } else {
      return WelcomeScreen();
    }
  }
}
