import 'package:flutter/material.dart';
import 'package:quiz_app/Authenticate/Loading.dart';
import 'package:quiz_app/Dialoges/LogoutDialog.dart';
import 'package:quiz_app/Services/Const.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final BlocToken bloc;
  final BlocTrophy blocTrophy;
  final SharedPreferences prefs;
  Profile({this.bloc, this.blocTrophy, this.prefs});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String name;
  int matchplayed, matchwins, matchlosse;

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

    widget.bloc.tokenEventSink.add(IncrementToken(0));
    widget.blocTrophy.trophyEventSink.add(Increment(trophy: 0));
    name = widget.prefs.getString('name');
    matchplayed = widget.prefs.getInt('matchplayed');
    matchwins = widget.prefs.getInt('matchwins');
    matchlosse = widget.prefs.getInt('matchlosses');
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: animation,
      child: Container(
        color: getColors[1],
        child: Column(
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 15,
              width: size.width / 1.2,
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () => showDialog(
                    context: context, builder: (_) => LogoutDialog()),
              ),
            ),
            Container(
              height: size.height / 4,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 4.5,
                width: size.width / 2.2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://media.istockphoto.com/photos/varanasi-ganges-river-ghat-with-ancient-city-architecture-as-viewed-picture-id1126057186?s=612x612')),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                    fontSize: size.width / 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Container(
              height: size.height / 8,
              width: size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width / 8,
                  ),
                  StreamBuilder(
                      stream: widget.blocTrophy.counter,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return Text(
                          "${snapshot.data}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        );
                      }),
                  SizedBox(
                    width: size.width / 40,
                  ),
                  Container(
                    height: size.height / 18,
                    width: size.height / 18,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/trophy.png'))),
                  ),
                  SizedBox(
                    width: size.width / 3,
                  ),
                  StreamBuilder(
                      stream: widget.bloc.token,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        );
                      }),
                  SizedBox(
                    width: size.width / 40,
                  ),
                  Container(
                    height: size.height / 18,
                    width: size.height / 18,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/rupee.png'))),
                  ),
                ],
              ),
            ),
            matchInfo(size),
          ],
        ),
      ),
    );
  }

  Widget matchInfo(Size size) {
    return Container(
      height: size.height / 8,
      width: size.width / 1.1,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text("Total Match\n      $matchplayed",
                  style: TextStyle(
                      fontSize: size.width / 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Wins\n        $matchwins",
                style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Loose\n        $matchlosse",
                style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFromLeaderBoard extends StatefulWidget {
  final String username;

  ProfileFromLeaderBoard({this.username});

  @override
  _ProfileFromLeaderBoardState createState() => _ProfileFromLeaderBoardState();
}

class _ProfileFromLeaderBoardState extends State<ProfileFromLeaderBoard> {
  bool isLoading = true;
  Map userdata;

  @override
  void initState() {
    super.initState();

    getUserDataFromServer(widget.username).then((userMap) {
      print(userMap);
      setState(() {
        userdata = userMap;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading == true
        ? Loading(
            text: "While we are Loading Profile Details",
          )
        : Scaffold(
            body: Container(
            color: getColors[1],
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 15,
                  width: size.width / 1.2,
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () => showDialog(
                        context: context, builder: (_) => LogoutDialog()),
                  ),
                ),
                Container(
                  height: size.height / 4,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 4.5,
                    width: size.width / 2.2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://media.istockphoto.com/photos/varanasi-ganges-river-ghat-with-ancient-city-architecture-as-viewed-picture-id1126057186?s=612x612')),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Container(
                  height: size.height / 10,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Text(
                    userdata['name'],
                    style: TextStyle(
                        fontSize: size.width / 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width / 8,
                      ),
                      Text(
                        userdata['trophy'].toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: size.width / 40,
                      ),
                      Container(
                        height: size.height / 18,
                        width: size.height / 18,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/trophy.png'))),
                      ),
                      SizedBox(
                        width: size.width / 3,
                      ),
                      Text(
                        userdata['tokens'].toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: size.width / 40,
                      ),
                      Container(
                        height: size.height / 18,
                        width: size.height / 18,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/rupee.png'))),
                      ),
                    ],
                  ),
                ),
                matchInfo(size),
              ],
            ),
          ));
  }

  Widget matchInfo(Size size) {
    return Container(
      height: size.height / 8,
      width: size.width / 1.1,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text("Total Match\n      ${userdata['matchplayed']}",
                  style: TextStyle(
                      fontSize: size.width / 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Wins\n        ${userdata['matchwins']}",
                style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Loose\n        ${userdata['matchlosses']}",
                style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
