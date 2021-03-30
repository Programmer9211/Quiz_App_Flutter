import 'package:flutter/material.dart';
import 'package:quiz_app/Authenticate/Loading.dart';
import 'package:quiz_app/Dialoges/Dialoges.dart';
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
          ? Loading(
              text: "While we are refreshing data",
            )
          : Container(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: size.height / 3,
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
                                        fontSize: size.width / 16.5,
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
                                          color: Colors.white,
                                          size: size.width / 14))
                                ],
                              ),
                              SizedBox(
                                height: size.height / 15,
                              ),
                              ListTile(
                                  leading: Text("1",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width / 18)),
                                  title: Text(list[0]['username'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width / 18)),
                                  subtitle: Text(
                                      "Tokens : ${list[0]['tokens']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width / 23)),
                                  trailing: Text((list[0]['trophy']).toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width / 18)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height / 1.7,
                    width: size.width,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8),
                          child: Peoples(
                            index: index,
                            list: widget.list,
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

class Peoples extends StatelessWidget {
  final int index;
  final List list;
  Peoples({this.index, this.list});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (_) => ViewProfile(
                name: list[index]['username'],
              )),
      child: Material(
        elevation: 5,
        color: getColors[1],
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: size.height / 10,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            color: getColors[1],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    fontSize: size.width / 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: size.width / 15,
              ),
              Container(
                height: size.height / 12,
                width: size.width / 1.7,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(list[index]['username'],
                        style: TextStyle(
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text("Tokens : ${list[index]['tokens']}",
                          style: TextStyle(
                              fontSize: size.width / 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height / 10,
                width: size.width / 10,
                alignment: Alignment.center,
                child: Text("${list[index]['trophy']}     ",
                    style: TextStyle(
                        fontSize: size.width / 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                height: size.height / 22,
                width: size.width / 20,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/trophy.png'),
                  fit: BoxFit.cover,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
