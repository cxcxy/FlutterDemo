import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class BillInfo extends StatefulWidget {
  BillInfo({Key key}) : super(key: key);

  @override
  _BillInfoState createState() => _BillInfoState();
}

class _BillInfoState extends State<BillInfo> {
  String title = 'Flutter to Native';
  Color backGroundColor = Colors.red;
// 注册一个通知
  static const MethodChannel methodChannel =
      const MethodChannel('com.pages.your/native_get');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: new Container(
            margin: new EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                BillInfoList(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 94,
                  // width: 150,
                  child: PayBtn(),
                )
              ],
            ),
            decoration: new BoxDecoration(
              //背景
              color: Color.fromRGBO(242, 242, 242, 1),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ),
    );
  }
}

class PayBtn extends StatefulWidget {
  PayBtn({Key key}) : super(key: key);

  @override
  _PayBtnState createState() => _PayBtnState();
}

class _PayBtnState extends State<PayBtn> {
  String title = '立即兑付';
  // 注册一个通知
  static const MethodChannel methodChannel =
      const MethodChannel('com.pages.your/native_get');
  // 取消监听
  VoidCallback _listenCancelable;
  handleMsg(String name, Map params) {
    if (name == "ToFlutterWithFlutterBoost") {
      title = params["version"];
      setState(() {});
    }
  }

//Dart调用Native方法，并接收返回值。
  flutterFromNativeValue() async {
    /// 使用flutter boost 向iOS发送消息
    Map<String, dynamic> tmp = Map<String, dynamic>();
    tmp["url"] = "pmiapi/public/apiversion";
    tmp["req"] = Map<String, dynamic>();
    try {
      FlutterBoost.singleton.channel
          .sendEvent('FlutterToNativeWithFlutterBoost', tmp);
    } catch (e) {}
  }

  @override
  void initState() {
    //flutter部分接收数据，dart代码
    _listenCancelable?.call();

    /// 在wight 中 只能出现一个  ToFlutterWithFlutterBoost 的监听，否则第二次会传递不过来
    _listenCancelable = FlutterBoost.singleton.channel
        .addEventListener("ToFlutterWithFlutterBoost", (name, arguments) async {
      // return handleMsg(name, arguments);
      // if (name == "ToFlutterWithFlutterBoost") {
      var msg = arguments["version"];
      if (msg != null) {
        title = msg;
        setState(() {});
      }
      return null;
    });
    super.initState();
  }

  @override
  void dispose() {
    // 取消监听 要加上取消监听，否则会造成内存泄露 在Xcode中有输出相关日志
    _listenCancelable.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Container(
        margin: new EdgeInsets.fromLTRB(15, 10, 15, 44),
        alignment: Alignment.center,
        child: RaisedButton(
          child: Text(title),
          onPressed: () {
            flutterFromNativeValue();
          },
        ),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(193, 0, 24, 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      color: Colors.white,
    );
  }
}

Widget redBox = DecoratedBox(
  decoration: BoxDecoration(
    color: Color.fromRGBO(193, 10, 24, 1),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

class BillInfoList extends StatelessWidget {
  const BillInfoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.fromLTRB(15, 20, 15, 112),
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 62,
          ),
          new ClipOval(
            child: Image.network(
              'https://f1.xb969.com/FtZl1ncYl-MfPpAIrkX1vbz6f1Q9',
              width: 40,
              height: 40,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '欧阳娜娜',
            style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '这是您在天目传奇的消费账单，请核实后兑付',
            style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1),
              fontSize: 13.0,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            '12000.00',
            style: TextStyle(
              color: Color.fromRGBO(219, 11, 11, 1),
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text('支付剩余时间'),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 170,
            width: 170,
            child: redBox,
          ),
        ],
      ),
    );
  }
}
