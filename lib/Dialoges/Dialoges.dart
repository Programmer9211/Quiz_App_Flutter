import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Sub%20Screens/QuizPage.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayWarning extends StatelessWidget {
  final int token;
  final BlocTrophy bloc;
  final BlocToken blocToken;
  final String name, url;
  final SharedPreferences prefs;
  PlayWarning(
      this.token, this.name, this.url, this.bloc, this.blocToken, this.prefs);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        name,
        style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
      ),
      content: Text(
          "You will be Charge $token tokens for playing this mode and if you answered more then 50% of questions you will win and if not you will loss tokens",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
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

            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => QuizPage(
                    bloc: bloc, blocToken: blocToken, url: url, prefs: prefs)));
          },
          child: Text("Play"),
        ),
      ],
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

      bloc.tokenEventSink.add(IncrementToken(25));
      Navigator.pop(context);

      sendTokensAndTrohiestoServer(username, map);
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
