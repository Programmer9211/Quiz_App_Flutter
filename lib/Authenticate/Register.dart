import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/HomePage.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _name = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isLoading = false;

  void onPressed() {
    if (_name.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _username.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      final Map<String, dynamic> _map = {
        "name": _name.text,
        "username": _username.text,
        "password": _password.text,
        "matchplayed": 0,
        "matchwins": 0,
        "matchlosses": 0,
        "tokens": 0,
        "trophy": 0
      };

      final Map<String, dynamic> _leaderboardData = {
        "username": _username.text,
        "tokens": 0,
        "trophy": 0
      };

      registerNewUser(_map).then((_) {
        setState(() {
          isLoading = false;
        });
        saveData().then((_) => print("Values Saved in Variables"));
        postDataToLeaderboard(_leaderboardData);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomePage()));
      });
    }
  }

  Future saveData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setString('name', _name.text);
    await _prefs.setString('username', _username.text);
    await _prefs.setString('password', _password.text);
    await _prefs.setInt('matchplayed', 0);
    await _prefs.setInt('matchwins', 0);
    await _prefs.setInt('matchlosses', 0);
    await _prefs.setInt('tokens', 0);
    await _prefs.setInt('trophy', 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading == true
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Create Account,",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Sign Up To Get Started!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 15,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: textField(size, 'Name', Icons.account_circle, _name),
                  ),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: textField(
                        size, 'username', Icons.account_box_rounded, _username),
                  ),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: textField(size, 'password', Icons.lock, _password),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Material(
                    elevation: 10,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    child: GestureDetector(
                      onTap: onPressed,
                      child: Container(
                        height: size.height / 12.5,
                        width: size.width / 1.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I'm Already a member,",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "SignIn",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () async {
            //     SharedPreferences pr = await SharedPreferences.getInstance();
            //     await pr.clear().then((l) {
            //       print(l);
            //       print("Done");
            //     });
            //   },
            // ),
          );
  }

  Widget textField(Size size, String title, IconData icon,
      TextEditingController controller) {
    return Container(
      width: size.width / 1.1,
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelText: title,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}
