import 'package:flutter/material.dart';

class Analysis extends StatefulWidget {
  final List list;
  Analysis({this.list});

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height / 2.5,
            width: size.width,
            color: Colors.purple[400],
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 15,
                ),
                Text(
                  "LeaderBoard",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            height: size.height / 2,
            width: size.width,
            child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Container(
                    height: size.height / 20,
                    width: size.width / 1.2,
                    child: ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      title: Text(widget.list[index]['username'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      trailing: Text("${widget.list[index]['trophy']}     ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      subtitle: Text("Tokens : ${widget.list[index]['tokens']}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
