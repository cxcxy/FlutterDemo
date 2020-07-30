import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
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
        home: ProvidePage(),
      ),
    );
  }
}

class ProvidePage extends StatefulWidget {
  ProvidePage({Key key}) : super(key: key);

  @override
  _ProvidePageState createState() => _ProvidePageState();
}

class _ProvidePageState extends State<ProvidePage> {
  // 取消监听
  VoidCallback _listenCancelable;
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

  showViewToNative() {
    try {
      FlutterBoost.singleton.channel.sendEvent('showView', {});
    } catch (e) {}
  }

  @override
  void initState() {
    //flutter部分接收数据，dart代码
    _listenCancelable?.call();

    /// 在wight 中 只能出现一个  ToFlutterWithFlutterBoost 的监听，否则第二次会传递不过来
    _listenCancelable = FlutterBoost.singleton.channel.addEventListener(
        "pmiapi/public/share/getinfobyauthcode", (name, arguments) async {
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
    return Scaffold(
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
  showViewToNative() {
    print("showView");
    try {
      FlutterBoost.singleton.channel
          .sendEvent('FlutterToNativeWithFlutterBoost', {'showView': true});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Container(
        margin: new EdgeInsets.fromLTRB(15, 10, 15, 44),
        alignment: Alignment.center,
        child: RaisedButton(
          child: Text(title),
          color: Colors.white,
          onPressed: () {
            showViewToNative();
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
  Map tmp = {'version': 'a1', 'b': 'b1'};
  dynamic getValue(key) => tmp[key];
  increment() {
    // 核心，知刷新UI,调用build方法
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
