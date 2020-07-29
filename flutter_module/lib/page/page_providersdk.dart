import 'package:provider/provider.dart';
// 一个通用的InheritedWidget，保存任需要跨组件共享的状态
import 'dart:collection';

import 'package:flutter/material.dart';

class ProviderSDKDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 创建 Widget 持有 CounterNotifier 数据
    return ChangeNotifierProvider.value(
      value: CounterNotifier(),
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
    final counter = Provider.of<CounterNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '按下按钮，使数字增长:',
            ),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
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

//  核心：继承自ChangeNotifier
// 这种文件本来应该单独放在一个类文件连的
class CounterNotifier with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  increment() {
    _count++;
    // 核心方法，通知刷新UI,调用build方法
    notifyListeners();
  }
}
