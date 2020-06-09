import 'dart:developer';

import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  final String text;
  final bool local;

  TestWidget(this.text, {Key key, this.local});

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  void initState() {
    super.initState();
    log("initState ${widget.text}");
  }

  @override
  void dispose() {
    super.dispose();
    log("dispose: ${widget.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.text + "other : ${widget.local}"),
      color: Colors.red,
      width: 100,
      height: 100,
    );
  }
}
