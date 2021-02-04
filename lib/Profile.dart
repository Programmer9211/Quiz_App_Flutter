import 'package:flutter/material.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';

class Profile extends StatefulWidget {
  final BlocToken bloc;
  final BlocTrophy blocTrophy;
  Profile({this.bloc, this.blocTrophy});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    widget.bloc.tokenEventSink.add(IncrementToken(0));
    widget.blocTrophy.trophyEventSink.add(Increment(trophy: 0));
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.amber[100],
      child: Column(
        children: [
          SizedBox(
            height: size.height / 12,
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
              "Player Name",
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
                "Total Match\n      10",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Wins\n        5",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                "Match Loose\n        5",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
