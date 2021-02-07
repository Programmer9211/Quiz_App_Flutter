import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final String url, name;
  final BlocTrophy bloc;
  final BlocToken blocToken;
  final SharedPreferences prefs;
  final int chargeToken;
  QuizPage(
      {this.bloc,
      this.url,
      this.name,
      this.blocToken,
      this.prefs,
      this.chargeToken});
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> questionList = List<String>();
  List<List<String>> answerList = List<List<String>>();
  List<String> correctAnswer = List<String>();
  bool isLoading;
  bool isPlayerWin;
  int counter = 0;
  int points = 0;
  int sec = 10;
  Timer timer;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getQuestionsListFromServer(widget.url).then((list) {
      setState(() {
        for (int i = 0; i <= list.length - 1; i++) {
          questionList.add(list[i]['question']);
          answerList.add([
            list[i]['correct_answer'],
            list[i]['incorrect_answers'][0],
            list[i]['incorrect_answers'][1],
            list[i]['incorrect_answers'][2]
          ]);
          correctAnswer.add(list[i]['correct_answer']);
        }
        isLoading = false;
      });

      runTimer();

      print(answerList);
    });
  }

  void runTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        sec = sec - 1;
      });
      if (sec == 0) {
        if (counter == 9) {
          result();
        } else {
          setState(() {
            counter++;
            answerList[counter].shuffle();
            sec = 20;
          });

          runTimer();
        }
      }
    });
  }

  void checkAnswer(String answer) {
    if (answer == correctAnswer[counter]) {
      print("Correct anwer");
      points++;
    } else {
      print("Wrong answer");
    }

    result();
  }

  void result() {
    int trophy, tokens;

    void _set() {
      setState(() {});
    }

    if (counter == 9) {
      timer.cancel();

      switch (points) {
        case 1:
          trophy = -7;
          tokens = 0;
          _set();
          break;
        case 2:
          trophy = -5;
          tokens = 0;
          _set();
          break;
        case 3:
          trophy = -3;
          tokens = 0;
          _set();
          break;
        case 4:
          trophy = -1;
          tokens = 0;
          _set();
          break;
        case 5:
          trophy = 2;
          tokens = 2;
          _set();
          break;
        case 6:
          trophy = 4;
          tokens = 4;
          _set();
          break;
        case 7:
          trophy = 6;
          tokens = 6;
          _set();
          break;
        case 9:
          trophy = 8;
          tokens = 9;
          _set();
          break;
        default:
          trophy = 10;
          tokens = 12;
          _set();
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => Result(
                isWin: isPlayerWin,
                trophies: trophy,
                bloc: widget.bloc,
                blocToken: widget.blocToken,
                tokens: tokens - widget.chargeToken,
                prefs: widget.prefs,
              )));

      timer.cancel();
    } else {
      timer.cancel();
      setState(() {
        counter++;
        answerList[counter].shuffle();
        sec = 20;
      });

      runTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: size.height / 25,
                ),
                Container(
                  height: size.height / 10,
                  width: size.width,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(
                        width: size.width / 5,
                      ),
                      Text(
                        "Quiz Page",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height / 7,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Text(
                    "Time Left : $sec sec",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: size.width / 1.1,
                  child: Text(
                    "Ques ${counter + 1}:  ${questionList[counter]}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 10,
                  width: size.width / 1.1,
                  child: GestureDetector(
                    onTap: () => checkAnswer(answerList[counter][0]),
                    child: Text("a  ${answerList[counter][0]}.",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  height: size.height / 10,
                  width: size.width / 1.1,
                  child: GestureDetector(
                    onTap: () => checkAnswer(answerList[counter][1]),
                    child: Text("b  ${answerList[counter][1]}.",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  height: size.height / 10,
                  width: size.width / 1.1,
                  child: GestureDetector(
                    onTap: () => checkAnswer(answerList[counter][2]),
                    child: Text("c  ${answerList[counter][2]}.",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  height: size.height / 10,
                  width: size.width / 1.1,
                  child: GestureDetector(
                    onTap: () => checkAnswer(answerList[counter][3]),
                    child: Text("d  ${answerList[counter][3]}.",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     answerList[0].shuffle();
            //     print(answerList[0]);
            //     setState(() {});
            //   },
            // ),
          );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class Result extends StatefulWidget {
  final String mess;
  final int trophies, tokens;
  final BlocTrophy bloc;
  final BlocToken blocToken;
  final SharedPreferences prefs;
  final bool isWin;

  Result(
      {this.mess,
      this.trophies,
      this.tokens,
      this.bloc,
      this.blocToken,
      this.prefs,
      this.isWin});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int trophies, tokens, matchplayed, matchwins, matchlooses;
  String username;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    tokens = widget.prefs.getInt('tokens');
    trophies = widget.prefs.getInt('trophy');
    matchplayed = widget.prefs.getInt('matchplayed');
    matchlooses = widget.prefs.getInt('matchlosses');
    matchwins = widget.prefs.getInt('matchwins');
    username = widget.prefs.getString('username');

    setState(() {});
  }

  void onContinue() async {
    if (widget.trophies.isNegative) {
      widget.bloc.trophyEventSink.add(Decrement(trophy: widget.trophies));
      print("Substracted ${widget.trophies}");
    } else {
      widget.bloc.trophyEventSink.add(Increment(trophy: widget.trophies));
      print("Added ${widget.trophies}");
    }

    if (widget.tokens.isNegative) {
      widget.blocToken.tokenEventSink.add(DecrementToken(widget.tokens));
    } else {
      widget.blocToken.tokenEventSink.add(IncrementToken(widget.tokens));
    }

    print("match Win = ${widget.isWin}");

    Map<String, dynamic> map = {
      "matchplayed": matchplayed + 1,
      "matchwins": widget.isWin == true ? matchwins + 1 : matchwins + 0,
      "matchlosses": widget.isWin == false ? matchlooses + 1 : matchlooses + 0,
      "tokens": widget.tokens + tokens,
      "trophy": widget.trophies + trophies
    };

    sendTokensAndTrohiestoServer(username, map).then((statusCode) {
      if (statusCode == 200 || statusCode == 201) {
        Map<String, dynamic> _leaderboard = {
          "username": widget.prefs.getString('username'),
          "tokens": widget.tokens + tokens,
          "trophy": widget.trophies + trophies
        };

        updateData();
        updateDataToLeaderboard(
            widget.prefs.getString('username'), _leaderboard);
      }
    });

    Navigator.pop(context);
  }

  void updateData() async {
    await widget.prefs.setInt('matchplayed', matchplayed + 1);
    await widget.prefs.setInt(
        'matchwins', widget.isWin == true ? matchwins + 1 : matchwins + 0);
    await widget.prefs.setInt('matchlosses',
        widget.isWin == false ? matchlooses + 1 : matchlooses + 0);
    await widget.prefs.setInt('tokens', widget.tokens + tokens);
    await widget.prefs.setInt('trophy', widget.trophies + trophies);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        onContinue();
      },
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Column(
          children: [
            SizedBox(
              height: size.height / 25,
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(
                    width: size.width / 8,
                  ),
                  Text(
                    "You Win this quiz",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            Text(
              "You Got",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 2.5,
              width: size.width / 1.1,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showRewards(size, 20, 'assets/rupee.png', "Tokens"),
                  Container(
                    width: size.width / 150,
                    height: size.height / 3,
                    color: Colors.white,
                  ),
                  showRewards(size, 7, 'assets/trophy.png', "Trophy"),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 5,
            ),
            Container(
              height: size.height / 10,
              width: size.width / 1.2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.white,
                      textColor: Colors.blue,
                      child: Text("Continue"),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () => onContinue(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showRewards(Size size, int value, String path, String name) {
    return Container(
      height: size.height / 3,
      width: size.width / 2.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$value",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                width: size.width / 40,
              ),
              Container(
                height: size.height / 15,
                width: size.height / 15,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(path))),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 40,
          ),
          Text(name,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white))
        ],
      ),
    );
  }
}
