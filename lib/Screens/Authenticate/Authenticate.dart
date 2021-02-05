import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Authenticate/Loading.dart';
import 'package:quiz_app/Screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';
import 'Register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String username;
  bool isnull;

  @override
  void initState() {
    check();
    super.initState();
  }

  void check() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance().then((l) {
      setState(() {
        isnull = false;
      });

      return l;
    });

    setState(() {
      username = _prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isnull == null) {
      return Loading();
    } else if (isnull == false) {
      if (username == null) {
        return WelcomeScreen();
      } else {
        return HomePage();
      }
    } else {
      return WelcomeScreen();
    }
  }
}

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
                fontSize: 30,
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
                  fontSize: 18,
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
                fontSize: 20,
                color: Colors.white,
                //color: color == Colors.blue ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
