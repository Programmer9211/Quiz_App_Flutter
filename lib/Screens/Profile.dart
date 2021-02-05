import 'package:flutter/material.dart';
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

class _ProfileState extends State<Profile> {
  String name;
  int matchplayed, matchwins, matchlosse;

  @override
  void initState() {
    super.initState();
    widget.bloc.tokenEventSink.add(IncrementToken(0));
    widget.blocTrophy.trophyEventSink.add(Increment(trophy: 0));
    name = widget.prefs.getString('name');
    matchplayed = widget.prefs.getInt('matchplayed');
    matchwins = widget.prefs.getInt('matchwins');
    matchlosse = widget.prefs.getInt('matchlosses');
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.amber[100],
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
              icon: Icon(Icons.logout),
              onPressed: () => logout(context),
            ),
          ),
          Container(
            height: size.height / 4,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 4.5,
              width: size.width / 2.5,
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
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
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                            fontSize: 18, fontWeight: FontWeight.w500),
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
              child: Text(
                "Total Match\n      $matchplayed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Wins\n        $matchwins",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Loose\n        $matchlosse",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
