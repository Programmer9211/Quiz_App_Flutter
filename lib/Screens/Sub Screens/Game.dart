import 'package:flutter/material.dart';

import 'package:quiz_app/Dialoges/Dialoges.dart';
import 'package:quiz_app/Dialoges/LogoutDialog.dart';
import 'package:quiz_app/Services/Const.dart';
import 'package:quiz_app/bloc/tokenEvent.dart';
import 'package:quiz_app/bloc/trophyEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  final List newList, rewardList;
  final BlocTrophy _bloc;
  final BlocToken blocToken;
  final SharedPreferences prefs;
  Game(this.newList, this._bloc, this.blocToken, this.prefs, this.rewardList);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  Animation animation;
  AnimationController controller, _controller;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        _controller.reset();
        _controller.forward();
      });

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    final CurvedAnimation curvedAnimation =
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    _controller.forward();

    widget.blocToken.tokenEventSink.add(IncrementToken(0));
    widget.newList.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: animation,
      child: Container(
        color: getColors[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height / 25),
            Container(
              height: size.height / 20,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Quiz Page",
                    style: TextStyle(
                        fontSize: size.width / 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: size.width / 5.5,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    // onPressed: () => Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (_) => Loading())),
                    onPressed: () => showDialog(
                        context: context, builder: (_) => LogoutDialog()),
                  ),
                  SizedBox(
                    width: size.width / 10,
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            Container(
              width: size.width,
              alignment: Alignment.center,
              color: getColors[1],
              child: header(size),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            builder(size)
          ],
        ),
      ),
    );
  }

  Widget header(Size size) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 10,
      child: Container(
        height: size.height / 9,
        width: size.width / 1.08,
        child: Row(
          children: [
            SizedBox(
              width: size.width / 100,
            ),
            Container(
              height: size.height / 9.5,
              width: size.width / 5.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://media.istockphoto.com/photos/varanasi-ganges-river-ghat-with-ancient-city-architecture-as-viewed-picture-id1126057186?s=612x612'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15)),
            ),
            Container(
              height: size.height / 10,
              width: size.width / 3.5,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height / 10,
                    width: size.width / 12,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/rupee.png'))),
                  ),
                  SizedBox(
                    width: size.width / 40,
                  ),
                  StreamBuilder(
                      stream: widget.blocToken.token,
                      initialData: 0,
                      builder: (BuildContext context, snapshot) {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        );
                      }),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 15,
              width: size.width / 150,
              child: Center(
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: size.width / 3.2,
              child: Text(
                "Get more tokens",
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width / 25.5),
              ),
            ),
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) {
                    if (widget.prefs.getInt("tokens") < 11) {
                      return FreeTokens(
                        prefs: widget.prefs,
                        bloc: widget.blocToken,
                      );
                    } else {
                      return Message(
                        content:
                            "You Already have ${widget.prefs.getInt('tokens')} Tokens",
                        title: "More Tokens",
                      );
                    }
                  }),
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.purple,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget builder(Size size) {
    final _animation = Tween(begin: 0.85, end: 1.0).animate(_controller);
    return Container(
      height: size.height / 1.4,
      width: size.width,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.newList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ScaleTransition(scale: _animation, child: item(size, index)),
          );
        },
      ),
    );
  }

  Widget item(Size size, int index) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      color: Colors.white,
      child: Container(
        height: size.height / 2.3,
        width: size.width / 1.05,
        child: Column(
          children: [
            Container(
              height: size.height / 3.4,
              width: size.width / 1.05,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.newList[index]['imageUrl']),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
            Container(
              height: size.height / 8,
              width: size.width / 1.05,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width / 30,
                  ),
                  Container(
                      height: size.height / 8,
                      width: size.width / 1.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event name : ${widget.newList[index]['name']}",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: size.width / 24,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: size.height / 200,
                          ),
                          tokensRequired(
                              size,
                              widget.newList[index]['token'] == 0
                                  ? "Charge : Free"
                                  : "Charge : ${widget.newList[index]['token']}"),
                          SizedBox(
                            height: size.height / 200,
                          ),
                          tokensRequired(size, "Reward: 12"),
                        ],
                      )),
                  SizedBox(),
                  Container(
                    width: size.width / 4,
                    child: RaisedButton(
                      color: getColors[1],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Play Now",
                        style: TextStyle(fontSize: size.width / 26.5),
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        if (widget.prefs.getInt('tokens') <
                            widget.newList[index]['token']) {
                          showDialog(
                              context: context,
                              builder: (_) => Message(
                                    title: "Tokens",
                                    content:
                                        "You Dot Have Enough Token To Play This Mode",
                                  ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => PlayWarning(
                                  widget.newList[index]['token'],
                                  widget.newList[index]['name'],
                                  widget.newList[index]['link'],
                                  widget._bloc,
                                  widget.blocToken,
                                  widget.prefs,
                                  widget.newList[index]['imageUrl']));
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tokensRequired(
    Size size,
    String show,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          show,
          style: TextStyle(
              color: Colors.purple,
              fontSize: size.width / 24,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: size.width / 100,
        ),
        Container(
          height: size.height / 30,
          width: size.width / 12,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/rupee.png'))),
        ),
      ],
    );
  }
}

class RouteToPage extends PageRouteBuilder {
  final Widget page;

  RouteToPage(
    this.page,
  ) : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animation, curve: Curves.fastOutSlowIn)),
                  child: child,
                ));
}
