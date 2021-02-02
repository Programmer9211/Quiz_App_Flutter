import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
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
                color: Colors.amber, borderRadius: BorderRadius.circular(20)),
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
        )
      ],
    );
  }
}
