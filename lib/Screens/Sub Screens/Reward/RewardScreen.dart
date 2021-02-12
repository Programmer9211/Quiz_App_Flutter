import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RewardScreen extends StatelessWidget {
  final List list;
  RewardScreen(this.list);

  bool isComplete = false;

  void _onComplete(int token) {
    //sendTokensAndTrohiestoServer();
  }

  void _onGO(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height / 6,
            width: size.width,
            color: Colors.redAccent,
            alignment: Alignment.center,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(
                  width: size.width / 5,
                ),
                Text(
                  "Reward Center",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            height: size.height / 8,
            width: size.width,
            color: Colors.redAccent,
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: size.height / 1.6,
              width: size.width / 1.1,
              child: Column(
                children: [
                  Container(
                    height: size.height / 15,
                    width: size.width / 1.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Today's Task",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: size.width / 4,
                        ),
                        Text(
                          "1/${list.length} Completed",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[600],
                  ),
                  Container(
                    height: size.height / 1.9,
                    width: size.width / 1.1,
                    child: builder(size, context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget builder(Size size, BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: items(size, context, index),
        );
      },
    );
  }

  Widget items(Size size, BuildContext context, int index) {
    return Container(
      height: size.height / 15,
      width: size.width / 1.1,
      child: Row(
        children: [
          SizedBox(
            width: size.width / 30,
          ),
          Container(
            width: size.width / 20,
            alignment: Alignment.center,
            child: Text(
              (list[index]['tokens']).toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: size.width / 100,
          ),
          Container(
            height: size.height / 25,
            width: size.height / 25,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/rupee.png'))),
          ),
          SizedBox(
            width: size.width / 20,
          ),
          Container(
            width: size.width / 2.15,
            child: Text(
              list[index]['title'],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          RaisedButton(
            child: Text(
              isComplete ? "Collect" : "GO",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            color: isComplete ? Colors.green[800] : Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed:
                isComplete ? () => _onComplete(10) : () => _onGO(context),
          )
        ],
      ),
    );
  }
}
