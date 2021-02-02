import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Info> dummyList = <Info>[
    Info(
        name: "Sports",
        token: null,
        url:
            "https://media.npr.org/assets/img/2020/06/10/gettyimages-200199027-001-b5fb3d8d8469ab744d9e97706fa67bc5c0e4fa40-s1600-c85.jpg"),
    Info(
        name: "Culture",
        token: 10,
        url: "https://www.greatplacetowork.com/images/ylnpfr6c.png"),
    Info(
        name: "History",
        token: 22,
        url: "https://www.indiaeducation.net/imagesvr_ce/795/historypic2.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: size.height / 15),
        Container(
          width: size.width,
          alignment: Alignment.center,
          child: header(size),
        ),
        SizedBox(
          height: size.height / 20,
        ),
        builder(size)
      ],
    );
  }

  Widget header(Size size) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 10,
      child: Container(
        height: size.height / 9,
        width: size.width / 1.08,
        child: Row(
          children: [
            Container(
              height: size.height / 10,
              width: size.width / 5.5,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: FlutterLogo(),
            ),
            Container(
              height: size.height / 10,
              width: size.width / 3.5,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height / 10,
                    width: size.width / 12,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/rupee.png'))),
                  ),
                  SizedBox(
                    width: size.width / 40,
                  ),
                  Text(
                    "25",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 15,
              width: size.width / 150,
              child: Center(
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: size.width / 3.2,
              child: Text(
                "Get more tokens",
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.purple,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget builder(Size size) {
    return Container(
      height: size.height / 1.5,
      width: size.width,
      child: ListView.builder(
        itemCount: dummyList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: item(size, index),
          );
        },
      ),
    );
  }

  Widget item(Size size, int index) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      color: Colors.white,
      child: Container(
        height: size.height / 2.5,
        width: size.width / 1.05,
        child: Column(
          children: [
            Container(
              height: size.height / 3.4,
              width: size.width / 1.05,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(dummyList[index].url),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
            Container(
              height: size.height / 10,
              width: size.width / 1.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: size.height / 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dummyList[index].name,
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: size.height / 200,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: size.height / 30,
                                width: size.width / 12,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/rupee.png'))),
                              ),
                              SizedBox(
                                width: size.width / 100,
                              ),
                              Text(
                                dummyList[index].token == null
                                    ? "Free"
                                    : "${dummyList[index].token}",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("Play Now"),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Info {
  final String url, name;
  final int token;

  Info({this.url, this.name, this.token});
}
