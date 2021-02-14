import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/HomePage.dart';
import 'package:quiz_app/Services/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isloading = false;
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  void _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future _onLogin() async {
    if (_username.text.isNotEmpty && _password.text.isNotEmpty) {
      setState(() {
        isloading = true;
      });

      Map<String, String> map = {
        'username': _username.text,
        'password': _password.text
      };

      userLogin(map).then((message) {
        if (message == "Username doesn't Exist") {
          setState(() {
            isloading = false;
          });
        } else if (message == "Login Sucessful") {
        } else {
          getUserDataFromServer(_username.text).then((map) {
            _setData(map).then((_) {
              print("Saved Sucessfully");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => HomePage()),
                  (Route<dynamic> route) => false);
            });
          });
        }
      });
    } else {
      print("Please Enter username and password");
    }
  }

  Future _setData(Map<String, dynamic> map) async {
    await _prefs.setString('name', map['name']);
    await _prefs.setString('username', map['username']);
    await _prefs.setString('password', map['password']);
    await _prefs.setInt('matchplayed', map['matchplayed']);
    await _prefs.setInt('matchwins', map['matchwins']);
    await _prefs.setInt('matchlosses', map['matchlosses']);
    await _prefs.setInt('tokens', map['tokens']);
    await _prefs.setInt('trophy', map['trophy']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isloading == true
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
                      "Welcome,",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Sign In to Continue!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 15,
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
                      onTap: _onLogin,
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
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 4.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I'm a New User,",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "SignUp",
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
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}
