import 'package:flutter/material.dart';
import 'package:quiz_app/Authenticate/Loading.dart';
import 'package:quiz_app/Services/Const.dart';
import 'package:quiz_app/Services/Network.dart';

class Analysis extends StatefulWidget {
  final List list;

  Analysis({this.list});

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  List list;

  @override
  void initState() {
    super.initState();
    list = widget.list;
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
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: animation,
      child: list == null
          ? Loading()
          : Container(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: size.height / 2.5,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: getColors[0],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height / 15,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: size.width / 3.5),
                                  Text(
                                    "LeaderBoard",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: size.width / 5.5),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          list = null;
                                        });
                                        getLeaderboardFromServer()
                                            .then((leaderboardList) {
                                          setState(() {
                                            list = leaderboardList;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.restore,
                                          color: Colors.white, size: 35))
                                ],
                              ),
                              SizedBox(
                                height: size.height / 10,
                              ),
                              ListTile(
                                  leading: Text("1",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25)),
                                  title: Text(list[0]['username'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25)),
                                  subtitle: Text(
                                      "Tokens : ${list[0]['tokens']}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  trailing: Text((list[0]['trophy']).toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height / 2,
                    width: size.width,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Container(
                            height: size.height / 20,
                            width: size.width / 1.2,
                            child: ListTile(
                              leading: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              title: Text(list[index]['username'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              trailing: Text("${list[index]['trophy']}     ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "Tokens : ${list[index]['tokens']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
