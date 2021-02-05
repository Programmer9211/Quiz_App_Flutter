import 'package:flutter/material.dart';

import 'Screens/Authenticate/Authenticate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quiz App",
      debugShowCheckedModeBanner: false,
      home: Authenticate(),
    );
  }
}
