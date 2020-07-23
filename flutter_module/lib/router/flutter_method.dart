import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    FlutterBoost.singleton
        .registerPageBuilders({'first': (pageName, params, _) => MethodDemo()});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(),
        home: Container(color: Colors.white));
  }
}

class MethodDemo extends StatefulWidget {
  MethodDemo({Key key}) : super(key: key);

  @override
  _MethodDemoState createState() => _MethodDemoState();
}

class _MethodDemoState extends State<MethodDemo> {
  String title = 'Flutter to Native';
  Color backGroundColor = Colors.red;

// 注册一个通知
  static const MethodChannel methodChannel =
      const MethodChannel('com.pages.your/native_get');

  //Dart调用Native方法，并接收返回值。
  _iOSPushToVC() async {
    title =
        await methodChannel.invokeMethod('FlutterToNative', {"type": "221133"});
    setState(() {
      backGroundColor = Colors.green;
    });
  }

  _MethodDemoState() {
    //Native调用Dart方法
    methodChannel.setMethodCallHandler((MethodCall call) {
      if (call.method == "NativeToFlutter") {
        setState(() {
          title = call.arguments;
          backGroundColor = Colors.yellow;
        });
      }
      return Future<dynamic>.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: new Text(title),
          onTap: () {
            _iOSPushToVC();
          },
        ),
      ),
    );
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
