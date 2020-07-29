import 'package:provider/provider.dart';
// 一个通用的InheritedWidget，保存任需要跨组件共享的状态
import 'dart:collection';

import 'package:flutter/material.dart';
// import './page_bill.dart';
import 'package:flutter_boost/flutter_boost.dart';

class BillProviderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 创建 Widget 持有 CounterNotifier 数据
    return ChangeNotifierProvider.value(
      value: BillInfoModel(),
      child: MaterialApp(
        title: 'Privoder Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProvidePage(title: 'Provider 测试页面'),
      ),
    );
  }
}

class ProvidePage extends StatelessWidget {
  final String title;

  ProvidePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ProvidePage build");
    // 获取 CounterNotifier 数据 （最简单的方式）
    final counter = Provider.of<BillInfoModel>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      // ),
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
      // Center(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         '按下按钮，使数字增长:',
      //       ),
      //       Text(
      //         '${counter.count}',
      //         style: Theme.of(context).textTheme.display1,
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
    tmp["url"] = "pmiapi/public/share/getinfobyauthcode";
    tmp["req"] = {'authCode': '12122fa931c14eaf'};
    // {authCode: "12122fa931c14eaf"}
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
      // var msg = arguments["version"];
      // if (msg != null) {
      //   title = msg;
      //   setState(() {});
      // }
      Provider.of<BillInfoModel>(context).setTmpValue(arguments);

      return null;
    });
    flutterFromNativeValue();
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
    final counter = Provider.of<BillInfoModel>(context);
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
              '${counter.getValue('createUserLogo')}',
              width: 40,
              height: 40,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '${counter.getValue('createUserDispname')}',
            style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '这是您在${counter.getValue('companyShortname')}的消费账单，请核实后兑付',
            style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1),
              fontSize: 13.0,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            '${counter.getValue('marketPrice')}',
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

//  核心：继承自ChangeNotifier
// 这种文件本来应该单独放在一个类文件连的
class BillInfoModel with ChangeNotifier {
  // int _count = 0;
  // Map<String, dynamic> tmp = Map<String, dynamic>();
  // tmp["version"] = "rrr";
  Map tmp = {'version': 'a1', 'b': 'b1'};
  //  tmp["url"] = "pmiapi/public/apiversion";
  // int get count => _count;
  dynamic getValue(key) => tmp[key];
  increment() {
    // _count++;
    // 核心方法，通知刷新UI,调用build方法
    notifyListeners();
  }

  setTmpValue(_tmp) {
    // print('setTmpValue(tmp)$_tmp');
    tmp = _tmp;
    // print('tmp====${tmp["version"]}');
    // 核心方法，通知刷新UI,调用build方法
    notifyListeners();
  }
}
