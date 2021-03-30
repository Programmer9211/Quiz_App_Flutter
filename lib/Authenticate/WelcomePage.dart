import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'Register.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 3,
            width: size.width,
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 5,
              child: Container(
                height: size.height / 3,
                width: size.width / 1.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('assets/quiz.jpg'),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            width: size.width / 1.25,
            alignment: Alignment.center,
            child: Text(
              "Welcome to Quiz App",
              style: TextStyle(
                fontSize: size.width / 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 30,
          ),
          Container(
            alignment: Alignment.center,
            width: size.width / 1.3,
            child: Text(
              "Where you can play awsome quiz \n                and win rewards ",
              style: TextStyle(
                  fontSize: size.width / 23,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(14, 176, 197, 1)),
            ),
          ),
          SizedBox(
            height: size.height / 10,
          ),
          customButton(
              size,
              () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginPage())),
              Color.fromRGBO(14, 176, 197, 1),
              "Login Now"),
          SizedBox(
            height: size.height / 30,
          ),
          customButton(
              size,
              () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => Register())),
              Colors.amber,
              "Create Account"),
        ],
      ),
    );
  }

  Widget customButton(Size size, Function func, Color color, String title) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: func,
        child: Container(
          height: size.height / 12,
          width: size.width / 1.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: color),
          child: Text(
            title,
            style: TextStyle(
              fontSize: size.width / 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
