import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';

class QuizPage extends StatefulWidget {
  final String url, name;
  final BlocTrophy bloc;
  final BlocToken blocToken;
  QuizPage({this.bloc, this.url, this.name, this.blocToken});
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> questionList = List<String>();
  List<List<String>> answerList = List<List<String>>();
  List<String> correctAnswer = List<String>();
  bool isLoading;
  int counter = 0;
  int points = 0;
  int sec = 30;
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
        timer.cancel();
        setState(() {
          counter++;
          answerList[counter].shuffle();
          sec = 30;
        });

        runTimer();
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

    if (counter == 9) {
      if (points == 4) {
        print("Draw");
      } else if (points > 4) {
        print("You Win");
      } else if (points < 4) {
        print("You Loose");
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => Result(
                trophies: 7,
                bloc: widget.bloc,
                blocToken: widget.blocToken,
                tokens: 12,
              )));

      timer.cancel();
    } else {
      timer.cancel();
      setState(() {
        counter++;
        answerList[counter].shuffle();
        sec = 30;
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

class Result extends StatelessWidget {
  final String mess;
  final int trophies, tokens;
  final BlocTrophy bloc;
  final BlocToken blocToken;

  Result({this.mess, this.trophies, this.tokens, this.bloc, this.blocToken});

  void onContinue(BuildContext context) async {
    if (trophies.isNegative) {
      bloc.trophyEventSink.add(Decrement(trophy: trophies));
      print("Substracted $trophies");
    } else {
      bloc.trophyEventSink.add(Increment(trophy: trophies));
      print("Added $trophies");
    }

    if (tokens.isNegative) {
      blocToken.tokenEventSink.add(DecrementToken(tokens));
    } else {
      blocToken.tokenEventSink.add(IncrementToken(tokens));
    }

    Map<String, dynamic> map = {
      "matchplayed": 20,
      "matchwins": 10,
      "matchlosses": 10,
      "tokens": 50,
      "trophy": 62
    };

    sendTokensAndTrohiestoServer('Colt', map);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
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
                    onPressed: () => onContinue(context),
                  ),
                ),
              ],
            ),
          )
        ],
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
