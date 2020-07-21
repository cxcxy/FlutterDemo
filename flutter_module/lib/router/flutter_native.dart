import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class MyIosApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyIosApp> {
  @override
  void initState() {
    super.initState();
    FlutterBoost.singleton.registerPageBuilders({
      'first': (pageName, params, _) => TestHello(
            title: params["key1"],
          )
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(),
        home: Container(color: Colors.white));
  }
}

class TestHello extends StatelessWidget {
  final String title;

  TestHello({this.title});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: RaisedButton(
      child: Text(title),
      onPressed: () {
        debugPrint("objecthahahaha");
        FlutterBoost.singleton.open("TwoViewController", urlParams: {
          "test": "flutter to flutter22222211113呃呃呃呃3 "
        }).then((Map value) {
          print(
              "call me when page is finished. did recieve native route result $value");
        });
      },
    )

        // Text(
        //   'hello3',
        //   textDirection: TextDirection.ltr, // 文字阅读方向
        //   style: TextStyle(
        //       fontSize: 40, fontWeight: FontWeight.bold, color: Colors.yellow),
        // ),
        );
  }
}
