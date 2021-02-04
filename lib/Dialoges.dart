import 'package:flutter/material.dart';
import 'package:quiz_app/QuizPage.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';

class PlayWarning extends StatelessWidget {
  final int token;
  final BlocTrophy bloc;
  final BlocToken blocToken;
  final String name, url;
  PlayWarning(this.token, this.name, this.url, this.bloc, this.blocToken);
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
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => QuizPage(
                    bloc: bloc,
                    blocToken: blocToken,
                    url: url,
                  ))),
          child: Text("Play"),
        ),
      ],
    );
  }
}
