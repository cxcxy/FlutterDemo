import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/page/page_provider.dart';
import '../page/page_bill.dart';
import '../page/safe_area.dart';
import '../page/content_page.dart';
import '../page/page_InheritedWidget.dart';
import '../page/page_providersdk.dart';
import '../page/page_bill_provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FlutterBoost.singleton.registerPageBuilders({
      'first': (pageName, params, _) => MethodDemo(),
      'billInfo': (pageName, params, _) => BillInfo(),
      'safeArea': (pageName, params, _) => SafeAreaDemo(),
      'contentPage': (pageName, params, _) => ContentPage(),
      'InheritedWidgetTestRoute': (pageName, params, _) =>
          InheritedWidgetTestRoute(),
      'ProviderSDKDemo': (pageName, params, _) => ProviderSDKDemo(),
      'BillProviderDemo': (pageName, params, _) => BillProviderDemo(),
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 750, height: 1334);
    return MaterialApp(
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(),
        home: BillProviderDemo());
  }
}

class MaterialAppDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
    /// 引入的 ScreenUtil 框架只能包在 StatelessWidget 的  build 方法里面
    ScreenUtil.init(context, width: 750, height: 1624, allowFontScaling: false);
    return Container(color: Colors.white);
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
    // title =
    //     await methodChannel.invokeMethod('FlutterToNative', {"type": "221133"});
    // setState(() {
    //   backGroundColor = Colors.green;
    // });
    /// 使用flutter boost 向iOS发送消息
    Map<String, dynamic> tmp = Map<String, dynamic>();
    tmp["type"] = "221133";
    try {
      FlutterBoost.singleton.channel
          .sendEvent('FlutterToNativeWithFlutterBoost', tmp);
    } catch (e) {}
  }

  _MethodDemoState() {
    FlutterBoost.singleton.channel.addEventListener('ToFlutterWithFlutterBoost',
        (name, arguments) {
      //todo
      if (name == "ToFlutterWithFlutterBoost") {
        setState(() {
          title = arguments["key"];
          backGroundColor = Colors.yellow;
        });
      }
      return;
    });

    // //Native调用Dart方法
    // methodChannel.setMethodCallHandler((MethodCall call) {
    //   if (call.method == "NativeToFlutter") {
    //     setState(() {
    //       title = call.arguments;
    //       backGroundColor = Colors.yellow;
    //     });
    //   }
    //   return Future<dynamic>.value();
    // });
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
      ),

      // Text(
      //   'hello3',
      //   textDirection: TextDirection.ltr, // 文字阅读方向
      //   style: TextStyle(
      //       fontSize: 40, fontWeight: FontWeight.bold, color: Colors.yellow),
      // ),
    );
  }
}
