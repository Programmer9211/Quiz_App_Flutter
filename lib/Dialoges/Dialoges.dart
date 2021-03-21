import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Sub%20Screens/Game.dart';
import 'package:quiz_app/Screens/Sub%20Screens/Quiz%20page/QuizPage.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayWarning extends StatefulWidget {
  final int chargeToken;
  final BlocTrophy bloc;
  final BlocToken blocToken;
  final String name, url;
  final SharedPreferences prefs;
  PlayWarning(this.chargeToken, this.name, this.url, this.bloc, this.blocToken,
      this.prefs);

  @override
  _PlayWarningState createState() => _PlayWarningState();
}

class _PlayWarningState extends State<PlayWarning>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    final CurvedAnimation curvedAnimation =
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.name,
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
        ),
        content: Text(
            "You will be Charge ${widget.chargeToken} tokens for playing this mode and if you answered more then 50% of questions you will win and if not you will loss tokens",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              controller.reverse();
              Timer(Duration(microseconds: 701), () {
                Navigator.pop(context);
              });
            },
            child: Text("Cancel"),
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);

              Navigator.of(context).push(RouteToPage(QuizPage(
                  bloc: widget.bloc,
                  blocToken: widget.blocToken,
                  url: widget.url,
                  prefs: widget.prefs,
                  chargeToken: widget.chargeToken)));
            },
            child: Text("Play"),
          ),
        ],
      ),
    );
  }
}

class FreeTokens extends StatefulWidget {
  final BlocToken bloc;
  final SharedPreferences prefs;

  FreeTokens({this.bloc, this.prefs});

  @override
  _FreeTokensState createState() => _FreeTokensState();
}

class _FreeTokensState extends State<FreeTokens>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    onPressed();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    final CurvedAnimation curvedAnimation =
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  void onPressed() async {
    String username = widget.prefs.getString('username');

    await widget.prefs.setInt('tokens', 25).then((_) {
      Map<String, dynamic> map = {
        "matchplayed": widget.prefs.getInt('matchplayed'),
        "matchwins": widget.prefs.getInt('matchwins'),
        "matchlosses": widget.prefs.getInt('matchlosses'),
        "tokens": widget.prefs.getInt('tokens'),
        "trophy": widget.prefs.getInt('trophy')
      };

      Map<String, dynamic> _leaderboardMap = {
        "username": username,
        "tokens": widget.prefs.getInt('tokens'),
        "trophy": 0
      };

      widget.bloc.tokenEventSink.add(IncrementToken(25));

      sendTokensAndTrohiestoServer(username, map);
      updateDataToLeaderboard(username, _leaderboardMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Free Token",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        content: Row(
          children: [
            Text(
              "You Got Free 25 ",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white),
            ),
            Container(
              height: size.height / 25,
              width: size.height / 25,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/rupee.png'),
                      fit: BoxFit.cover)),
            )
          ],
        ),
        actions: [
          FlatButton(
            textColor: Colors.white,
            child: Text("Thanks"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

class Message extends StatefulWidget {
  final String title, content;

  Message({this.title, this.content});

  @override
  _MessageCountState createState() => _MessageCountState();
}

class _MessageCountState extends State<Message>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

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
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
        ),
        content: Text(widget.content,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
