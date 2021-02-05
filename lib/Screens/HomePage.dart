import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/Dialoges/Dialoges.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Analysis.dart';
import 'Game.dart';
import 'Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  List eventsList;
  bool isLoading;
  SharedPreferences prefs;
  BlocTrophy _bloc;
  BlocToken _blocToken;

  @override
  void initState() {
    initializePrefs();
    super.initState();
    isLoading = true;
    getEventsFromServer().then((list) {
      setState(() {
        eventsList = list;
        isLoading = false;
      });
      _blocToken = BlocToken()..initialize(prefs.getInt('tokens'));
      _bloc = BlocTrophy()..initialize(prefs.getInt('trophy'));
      if (prefs.getInt('tokens') == 0) {
        givenToken();
      }
    });
  }

  void initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void givenToken() {
    Timer(Duration(seconds: 2), () {
      showDialog(
        context: context,
        builder: (_) => FreeTokens(
          bloc: _blocToken,
          prefs: prefs,
        ),
        barrierDismissible: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          if (currentIndex == 1) {
            return isLoading == true
                ? Center(child: CircularProgressIndicator())
                : Game(eventsList, _bloc, _blocToken, prefs);
          } else if (currentIndex == 0) {
            return Analysis();
          } else {
            return Profile(
              bloc: _blocToken,
              blocTrophy: _bloc,
              prefs: prefs,
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Games"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
