import 'package:agora_rtc_engine_example/src/widget/test.dart';
import 'package:agora_rtc_engine_example/src/widget/test_platform.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/huawei_rtc_engine.dart';


class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> list = [];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appbarTitle'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('You tapped the FAB $_index times'),
            ),
            ...getWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _index++;
          list.add("title: $_index");
        }),
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  getWidget() {
    return list.map((it) {
      if (it.contains("1")) {
        return RtcRenderWidget(
          it,
          local: true,
        );
      } else {
        return RtcRenderWidget(it);
      }
    }).toList();
  }
}
