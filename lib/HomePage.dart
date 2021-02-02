import 'package:flutter/material.dart';

import 'Analysis.dart';
import 'Game.dart';
import 'Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  final List page = [Analysis(), Game(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[currentIndex],
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
