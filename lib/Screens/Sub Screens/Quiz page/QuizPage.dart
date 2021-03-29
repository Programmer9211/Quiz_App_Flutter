import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/Authenticate/Loading.dart';
import 'package:quiz_app/Services/Const.dart';
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

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  List<String> questionList = List<String>();
  List<List<String>> answerList = List<List<String>>();
  List<String> correctAnswer = List<String>();
  List<Color> colors = List<Color>();
  bool isLoading;
  bool isPlayerWin;
  int counter = 0;
  int points = 0;
  int sec = 20;
  Timer timer;
  int hintfee = 0;
  Color bulbColor = Colors.white;

  AnimationController _controller, _hintAnimation;

  @override
  void initState() {
    for (int i = 0; i <= 3; i++) {
      colors.add(Colors.white);
    }

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _hintAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _controller.forward();
    _hintAnimation.forward();

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
            colors[0] = Colors.white;
            colors[1] = Colors.white;
            colors[2] = Colors.white;
            colors[3] = Colors.white;
          });
          _controller.reset();
          _controller.forward();
        }
      }
    });
  }

  void checkAnswer(String answer) {
    for (int i = 0; i <= 3; i++) {
      setState(() {
        colors[0] = Colors.white;
        colors[1] = Colors.white;
        colors[2] = Colors.white;
        colors[3] = Colors.white;
      });
    }

    if (answer == correctAnswer[counter]) {
      print("Correct anwer");
      points++;
    } else {
      print("Wrong answer");
    }

    result();
    _controller.reset();
    _controller.forward();
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
          isPlayerWin = false;
          _set();
          break;
        case 2:
          trophy = -5;
          tokens = 0;
          isPlayerWin = false;
          _set();
          break;
        case 3:
          trophy = -3;
          tokens = 0;
          isPlayerWin = false;
          _set();
          break;
        case 4:
          trophy = -1;
          tokens = 0;
          isPlayerWin = false;
          _set();
          break;
        case 5:
          trophy = 2;
          tokens = 2;
          isPlayerWin = true;
          _set();
          break;
        case 6:
          trophy = 4;
          tokens = 4;
          isPlayerWin = true;
          _set();
          break;
        case 7:
          trophy = 6;
          tokens = 6;
          isPlayerWin = true;
          _set();
          break;
        case 9:
          trophy = 8;
          tokens = 9;
          isPlayerWin = true;
          _set();
          break;
        default:
          trophy = 10;
          tokens = 12;
          isPlayerWin = true;
          _set();
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => Result(
                isWin: isPlayerWin,
                correctAns: points,
                trophies: trophy,
                bloc: widget.bloc,
                blocToken: widget.blocToken,
                tokens: tokens,
                totalToken: (tokens - widget.chargeToken) - hintfee,
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

  void onHint() {
    _hintAnimation.reset();
    bulbColor = Colors.yellow;
    setState(() {});
    _hintAnimation.forward();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        bulbColor = Colors.white;
      });
    });

    if (answerList[counter][0] == correctAnswer[counter]) {
      colors[0] = Colors.green;
      setState(() {});
    } else if (answerList[counter][1] == correctAnswer[counter]) {
      colors[1] = Colors.green;
      setState(() {});
    } else if (answerList[counter][2] == correctAnswer[counter]) {
      colors[2] = Colors.green;
      setState(() {});
    } else if (answerList[counter][3] == correctAnswer[counter]) {
      colors[3] = Colors.green;
      setState(() {});
    }
    setState(() {
      hintfee = hintfee + 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final animation =
        Tween(begin: Offset(1.0, 0.0), end: Offset.zero).animate(_controller);
    final hintAnimation =
        Tween<double>(begin: 2.0, end: 1.0).animate(_hintAnimation);

    return isLoading == true
        ? Loading()
        : Scaffold(
            body: Container(
              height: size.height,
              width: size.width,
              color: getColors[0],
              child: Column(
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
                          icon: Icon(Icons.arrow_back_ios_outlined,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: size.width / 5,
                        ),
                        Text(
                          "Quiz Page",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        SizedBox(width: size.width / 5),
                        GestureDetector(
                            onTap: () => onHint(),
                            child: AnimatedBuilder(
                              animation: hintAnimation,
                              child: Icon(Icons.lightbulb,
                                  color: bulbColor, size: 35),
                              builder: (BuildContext context, Widget child) {
                                return ScaleTransition(
                                  scale: hintAnimation,
                                  child: child,
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height / 7,
                    width: size.width,
                    alignment: Alignment.center,
                    child: Text(
                      "Time Left : $sec sec",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    child: requiredchild(size),
                    builder: (context, child) {
                      return SlideTransition(
                        position: animation,
                        child: child,
                      );
                    },
                  ),
                ],
              ),
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

  Widget requiredchild(Size size) {
    return Column(
      children: [
        Container(
          width: size.width / 1.1,
          child: Text(
            "Ques ${counter + 1}:  ${questionList[counter]}",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        SizedBox(
          height: size.height / 40,
        ),
        Divider(
          color: Colors.white,
        ),
        Container(
          height: size.height / 15,
          width: size.width / 1.1,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => checkAnswer(answerList[counter][0]),
            child: Text("a  ${answerList[counter][0]}.",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: colors[0])),
          ),
        ),
        Divider(
          color: Colors.white,
        ),
        Container(
          height: size.height / 15,
          width: size.width / 1.1,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => checkAnswer(answerList[counter][1]),
            child: Text("b  ${answerList[counter][1]}.",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: colors[1])),
          ),
        ),
        Divider(
          color: Colors.white,
        ),
        Container(
          height: size.height / 15,
          width: size.width / 1.1,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => checkAnswer(answerList[counter][2]),
            child: Text("c  ${answerList[counter][2]}.",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: colors[2])),
          ),
        ),
        Divider(
          color: Colors.white,
        ),
        Container(
          height: size.height / 15,
          width: size.width / 1.1,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => checkAnswer(answerList[counter][3]),
            child: Text("d  ${answerList[counter][3]}.",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: colors[3])),
          ),
        ),
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class Result extends StatefulWidget {
  final String mess;
  final int trophies, tokens, correctAns, totalToken;
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
      this.isWin,
      this.correctAns,
      this.totalToken});

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
    print(widget.totalToken);
    if (widget.trophies.isNegative) {
      if (trophies <= 10) {
        widget.bloc.trophyEventSink.add(Decrement(trophy: trophies));
        print("No Trophy Substracted Substracted");
      } else {
        widget.bloc.trophyEventSink.add(Decrement(trophy: widget.trophies));
        print("Substracted ${widget.trophies}");
      }
    } else {
      widget.bloc.trophyEventSink.add(Increment(trophy: widget.trophies));
      print(
          "Added ${widget.trophies} trophi $trophies Tokens ${widget.tokens}");
    }

    print("Tokens ${widget.tokens}");

    if (widget.totalToken.isNegative) {
      if (tokens <= 10) {
        widget.blocToken.tokenEventSink.add(DecrementToken(0));
      } else {
        widget.blocToken.tokenEventSink.add(IncrementToken(widget.totalToken));
      }
    } else {
      widget.blocToken.tokenEventSink.add(IncrementToken(widget.totalToken));
    }

    print("match Win = ${widget.isWin}");

    if (widget.trophies.isNegative) {
      if (trophies <= 10) {
        print(":) $trophies");
        Map<String, dynamic> map = {
          "matchplayed": matchplayed + 1,
          "matchwins": widget.isWin == true ? matchwins + 1 : matchwins + 0,
          "matchlosses":
              widget.isWin == false ? matchlooses + 1 : matchlooses + 0,
          "tokens": widget.totalToken + tokens,
          "trophy": widget.prefs.getInt('trophy')
        };

        sendTokensAndTrohiestoServer(username, map).then((statusCode) {
          if (statusCode == 200 || statusCode == 201) {
            Map<String, dynamic> _leaderboard = {
              "username": widget.prefs.getString('username'),
              "tokens": widget.totalToken + tokens,
              "trophy": widget.prefs.getInt('trophy')
            };

            updateData(0);
            updateDataToLeaderboard(
                widget.prefs.getString('username'), _leaderboard);
          }
        });
      } else {
        Map<String, dynamic> map = {
          "matchplayed": matchplayed + 1,
          "matchwins": widget.isWin == true ? matchwins + 1 : matchwins + 0,
          "matchlosses":
              widget.isWin == false ? matchlooses + 1 : matchlooses + 0,
          "tokens": widget.totalToken + tokens,
          "trophy": widget.trophies + trophies
        };

        sendTokensAndTrohiestoServer(username, map).then((statusCode) {
          if (statusCode == 200 || statusCode == 201) {
            Map<String, dynamic> _leaderboard = {
              "username": widget.prefs.getString('username'),
              "tokens": widget.totalToken + tokens,
              "trophy": widget.trophies + widget.prefs.getInt('trophy')
            };

            updateData(widget.trophies);
            updateDataToLeaderboard(
                widget.prefs.getString('username'), _leaderboard);
          }
        });
      }
    } else {
      Map<String, dynamic> map = {
        "matchplayed": matchplayed + 1,
        "matchwins": widget.isWin == true ? matchwins + 1 : matchwins + 0,
        "matchlosses":
            widget.isWin == false ? matchlooses + 1 : matchlooses + 0,
        "tokens": widget.totalToken + tokens,
        "trophy": widget.trophies + trophies
      };

      sendTokensAndTrohiestoServer(username, map).then((statusCode) {
        if (statusCode == 200 || statusCode == 201) {
          Map<String, dynamic> _leaderboard = {
            "username": widget.prefs.getString('username'),
            "tokens": widget.totalToken + tokens,
            "trophy": widget.trophies + widget.prefs.getInt('trophy')
          };

          updateData(widget.trophies);
          updateDataToLeaderboard(
              widget.prefs.getString('username'), _leaderboard);
        }
      });
    }

    Navigator.pop(context);
  }

  void updateData(int trophy) async {
    await widget.prefs.setInt('matchplayed', matchplayed + 1);
    await widget.prefs.setInt(
        'matchwins', widget.isWin == true ? matchwins + 1 : matchwins + 0);
    await widget.prefs.setInt('matchlosses',
        widget.isWin == false ? matchlooses + 1 : matchlooses + 0);
    await widget.prefs.setInt('tokens', widget.totalToken + tokens);
    await widget.prefs.setInt('trophy', trophy + widget.prefs.getInt('trophy'));
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
        backgroundColor: getColors[0],
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
                    onPressed: () => onContinue(),
                  ),
                  SizedBox(
                    width: size.width / 8,
                  ),
                  Text(
                    widget.correctAns >= 6
                        ? "You Win this quiz"
                        : "You Loose this quiz",
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
                  color: getColors[3], borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showRewards(
                      size, widget.tokens, 'assets/rupee.png', "Tokens"),
                  Container(
                    width: size.width / 150,
                    height: size.height / 3,
                    color: Colors.white,
                  ),
                  showRewards(
                      size, widget.trophies, 'assets/trophy.png', "Trophy"),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: size.height / 4.5,
              width: size.width / 1.2,
              child: Text(
                  "Correct Answers: ${widget.correctAns} \n \nWrong Answers: ${10 - widget.correctAns}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  )),
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
