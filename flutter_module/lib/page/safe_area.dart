import 'package:flutter/material.dart';

// class SafeArea extends StatelessWidget {
//   const SafeArea({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('data'),
//     );
//   }
// }
class SafeAreaDemo extends StatefulWidget {
  SafeAreaDemo({Key key}) : super(key: key);

  @override
  _SafeAreaDemoState createState() => _SafeAreaDemoState();
}

class _SafeAreaDemoState extends State<SafeAreaDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: SizedBox.expand(
          child: Card(color: Colors.yellowAccent),
        ),
      ),
    );
  }
}
