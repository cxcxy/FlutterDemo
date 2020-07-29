import 'package:provider/provider.dart';
// 一个通用的InheritedWidget，保存任需要跨组件共享的状态
import 'dart:collection';

import 'package:flutter/material.dart';

class ProviderConsumerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 创建 Widget 持有 CounterNotifier 数据
    return ChangeNotifierProvider<CounterNotifier>.value(
      value: CounterNotifier(),
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        Provider.value(value: 36),
        ChangeNotifierProvider.value(value: CounterNotifier())
      ],
      child: MaterialApp(
        title: 'Privoder Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Page1(),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //获取文字大小
    final size = Provider.of<int>(context).toDouble();
    // 获取计数
    final counter = Provider.of<CounterNotifier>(context);
    // 调用 build 时输出
    print('rebuild page 1');
    return Scaffold(
      appBar: AppBar(
        title: Text('Page1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 显示计数
            Text(
              'Current count: ${counter.count}',
              // 设置文字大小
              style: TextStyle(
                fontSize: size,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            // 跳转 Page2
            RaisedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Page2()),
              ),
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('rebuild page 2');
    return Scaffold(
      appBar: AppBar(
        title: Text('Page2'),
      ),
      body: Center(
        child: Consumer2<CounterNotifier, int>(
            builder: (context, counter, size, _) {
          print('rebuild page 2 refresh count');

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${counter.count}',
                style: TextStyle(
                  fontSize: size.toDouble(),
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 不需要监听改变（listen: false 不会重新调用build）
          Provider.of<CounterNotifier>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterNotifier with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  increment() {
    _count++;
    notifyListeners();
  }
}
