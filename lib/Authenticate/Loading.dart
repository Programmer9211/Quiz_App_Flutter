import 'package:flutter/material.dart';
import 'package:quiz_app/Services/Const.dart';

class Loading extends StatefulWidget {
  String text, reward, charge, image;

  Loading({this.text, this.reward, this.charge, this.image});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: getColors[1],
        body: Container(
            height: size.height,
            width: size.width,
            child: Column(children: [
              SizedBox(
                height: size.height / 15,
              ),
              Text(
                "Quiz App",
                style: TextStyle(
                    fontSize: size.width / 12.9,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: size.height / 15,
              ),
              Container(
                height: size.height / 4,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('assets/quiz.jpg'),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: size.height / 10,
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
                height: size.height / 8,
              ),
              Text(
                "Please wait...",
                style: TextStyle(
                    fontSize: size.width / 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                height: size.height / 40,
              ),
              Text(
                  widget.image == null
                      ? widget.text
                      : "While the quiz content is loading",
                  style:
                      TextStyle(fontSize: size.width / 18, color: Colors.white))
            ])));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
