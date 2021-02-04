import 'package:flutter/material.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';

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

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getEventsFromServer().then((list) {
      setState(() {
        eventsList = list;
        isLoading = false;
      });
    });
  }

  final List page = [
    Analysis(),
    Game(List(), null, null),
    Profile(
      bloc: null,
    )
  ];

  BlocTrophy _bloc = BlocTrophy();
  BlocToken _blocToken = BlocToken();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          if (currentIndex == 1) {
            return isLoading == true
                ? Center(child: CircularProgressIndicator())
                : Game(eventsList, _bloc, _blocToken);
          } else if (currentIndex == 0) {
            return Analysis();
          } else {
            return Profile(
              bloc: _blocToken,
              blocTrophy: _bloc,
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
