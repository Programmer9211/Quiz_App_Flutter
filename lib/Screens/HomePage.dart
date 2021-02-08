import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/Dialoges/Dialoges.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/PageEvent.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Sub Screens/Analysis.dart';
import 'Sub Screens/Game.dart';
import 'Sub Screens/Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 1;

  List eventsList, getLeaderboard, rewardList;
  bool isLoading, isShrink;
  SharedPreferences prefs;
  BlocTrophy _bloc;
  BlocToken _blocToken;
  PageEvent _pageEvent;

  @override
  void initState() {
    initializePrefs();
    super.initState();
    isLoading = true;
    isShrink = true;
    _pageEvent = PageEvent()..init(currentIndex, isShrink);
    getRewardList().then((list) {
      setState(() {
        rewardList = list;
        print(list);
      });
    });
    getLeaderboardFromServer().then((list) {
      setState(() {
        getLeaderboard = list;
        print(list);
      });
    });
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
        body: StreamBuilder(
            stream: _pageEvent.pageState,
            initialData: currentIndex,
            builder: (context, snapshot) {
              return Builder(
                builder: (BuildContext context) {
                  if (snapshot.data == 1) {
                    return isLoading == true
                        ? Center(child: CircularProgressIndicator())
                        : Game(
                            eventsList, _bloc, _blocToken, prefs, rewardList);
                  } else if (snapshot.data == 0) {
                    return Analysis(
                      list: getLeaderboard,
                    );
                  } else {
                    return Profile(
                      bloc: _blocToken,
                      blocTrophy: _bloc,
                      prefs: prefs,
                    );
                  }
                },
              );
            }),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.blueAccent,
        //   currentIndex: currentIndex,
        //   onTap: (index) {
        //     setState(() {
        //       currentIndex = index;
        //     });
        //   },
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.analytics,
        //         color: Colors.white,
        //       ),
        //       label: 'Analysis',
        //     ),
        //     BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Games"),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.account_box_outlined), label: 'Profile'),
        //   ],
        // ),

        floatingActionButton: StreamBuilder(
            stream: _pageEvent.boolState,
            initialData: true,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return FloatingActionButton(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.add),
                  onPressed: () {
                    _pageEvent.getBool.add(false);
                  },
                );
              } else {
                return Buttons(
                  pageEvent: _pageEvent,
                );
              }
            }));
  }
}

class Buttons extends StatefulWidget {
  final PageEvent pageEvent;

  Buttons({this.pageEvent});

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    final CurvedAnimation curvedAnimation =
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      alignment: Alignment.bottomRight,
      child: Container(
        height: size.height / 2.8,
        width: size.width / 7,
        child: ScaleTransition(
          scale: animation,
          child: Column(
            children: [
              FloatingActionButton(
                tooltip: "LeaderBoard",
                child: Icon(Icons.analytics_outlined),
                onPressed: () {
                  widget.pageEvent.pageIndex.add(0);
                  widget.pageEvent.getBool.add(true);
                },
              ),
              SizedBox(
                height: size.height / 50,
              ),
              FloatingActionButton(
                tooltip: "Games",
                child: Icon(Icons.gamepad),
                onPressed: () {
                  widget.pageEvent.pageIndex.add(1);
                  widget.pageEvent.getBool.add(true);
                },
              ),
              SizedBox(
                height: size.height / 50,
              ),
              FloatingActionButton(
                  tooltip: "Profile",
                  child: Icon(Icons.account_box_outlined),
                  onPressed: () {
                    widget.pageEvent.pageIndex.add(2);
                    widget.pageEvent.getBool.add(true);
                  }),
              SizedBox(
                height: size.height / 50,
              ),
              FloatingActionButton(
                tooltip: "Close",
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.pageEvent.getBool.add(true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
