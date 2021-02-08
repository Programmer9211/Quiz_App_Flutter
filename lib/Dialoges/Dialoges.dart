import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Sub%20Screens/Game.dart';
import 'package:quiz_app/Screens/Sub%20Screens/QuizPage.dart';
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
            onPressed: () => Navigator.pop(context),
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

class FreeTokens extends StatelessWidget {
  final BlocToken bloc;
  final SharedPreferences prefs;

  FreeTokens({this.bloc, this.prefs});

  void onPressed(BuildContext context) async {
    String username = prefs.getString('username');

    await prefs.setInt('tokens', 25).then((_) {
      Map<String, dynamic> map = {
        "matchplayed": prefs.getInt('matchplayed'),
        "matchwins": prefs.getInt('matchwins'),
        "matchlosses": prefs.getInt('matchlosses'),
        "tokens": prefs.getInt('tokens'),
        "trophy": prefs.getInt('trophy')
      };

      Map<String, dynamic> _leaderboardMap = {
        "username": username,
        "tokens": prefs.getInt('tokens'),
        "trophy": 0
      };

      bloc.tokenEventSink.add(IncrementToken(25));
      Navigator.pop(context);

      sendTokensAndTrohiestoServer(username, map);
      updateDataToLeaderboard(username, _leaderboardMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Free Token",
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w500, color: Colors.amber),
      ),
      content: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You Got Free 25 ",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18, color: Colors.amber),
          ),
          Container(
            height: size.height / 25,
            width: size.height / 25,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/rupee.png'), fit: BoxFit.cover)),
          )
        ],
      ),
      actions: [
        FlatButton(
          textColor: Colors.amber,
          child: Text("Thanks"),
          onPressed: () => onPressed(context),
        )
      ],
    );
  }
}
