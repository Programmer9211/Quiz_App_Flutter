import 'package:flutter/material.dart';
import 'package:quiz_app/Services/Const.dart';

class LoadingScreen extends StatefulWidget {
  final int percentage;
  LoadingScreen({this.percentage});
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  bool ishalf = false;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation = Tween(begin: 1.0, end: 2.0).animate(controller);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
  }

  double indicator() {
    final width = MediaQuery.of(context).size.width / 1.2;

    if (widget.percentage == 25) {
      return (width / 2) / 2;
    } else if (widget.percentage == 50) {
      return width / 2;
    } else if (widget.percentage == 75) {
      return (width / 2) / 2;
    } else {
      return width / 100000;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: getColors[3],
      body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(
                height: size.height / 15,
              ),
              Text(
                "Quiz App",
                style: TextStyle(
                    fontSize: size.width / 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: size.height / 15,
              ),
              Container(
                height: size.height / 3.3,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/quiz.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 15,
              ),
              AnimatedBuilder(
                  animation: animation,
                  child: Container(
                    height: size.height / 8,
                    width: size.height / 8,
                    decoration: BoxDecoration(
                        image:
                            DecorationImage(image: AssetImage('assets/q.png'))),
                  ),
                  builder: (context, child) {
                    return RotationTransition(
                      turns: animation,
                      child: child,
                    );
                  }),
              SizedBox(
                height: size.height / 10,
              ),
              Text(
                "Connecting to Server...",
                style: TextStyle(
                    fontSize: size.width / 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: size.height / 40,
              ),
              Container(
                alignment: widget.percentage == 75
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                height: size.height / 25,
                width: size.width / 1.2,
                decoration: BoxDecoration(
                    color:
                        widget.percentage == 75 ? getColors[1] : getColors[3],
                    border: Border.all(width: 1.0, color: Colors.black)),
                child: Container(
                  height: size.height / 25,
                  decoration: BoxDecoration(
                    color:
                        widget.percentage == 75 ? getColors[3] : getColors[1],
                  ),
                  width: indicator(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "    ${widget.percentage}%\nLoading...",
                  style: TextStyle(
                      fontSize: size.width / 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
