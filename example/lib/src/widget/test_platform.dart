import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/huawei_rtc_engine.dart';

/// 封装好的视频界面Widget - This widget will automatically manage the native view.
///
/// Enables create native view with `uid` `mode` `local` and destroy native view automatically.
///
class TestRenderWidget extends StatefulWidget {
  /// uid
  final String uid;

  /// local flag
  final bool local;

  TestRenderWidget(
    this.uid, {
    Key key,
    this.local = false,
  });

  @override
  State<StatefulWidget> createState() => _TestRenderWidgetState();
}

class _TestRenderWidgetState extends State<TestRenderWidget> {
  Widget _nativeView;
  int _viewId;

  @override
  void initState() {
    super.initState();
    log("initState: ${widget.uid}");
    _nativeView =

//        Text("uid: ${widget.uid}");
        HwRtcEngine.createNativeView((viewId) {
      _viewId = viewId;
//      _bindView();
    });
  }

  @override
  void dispose() {
    log("dispose: ${widget.uid},  viewId： $_viewId ");
//    HwRtcEngine.removeNativeView(_viewId);
    super.dispose();
  }

//  @override
//  void didUpdateWidget(RtcRenderWidget oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    log("didUpdateWidget uid: ${widget.uid}, oldWidget: $oldWidget");
//    if ((widget.uid != oldWidget.uid && widget.local != oldWidget.local) &&
//        _viewId != null) {
//      _bindView();
//      return;
//    }
//  }

//  void _bindView() {
//    if (widget.local) {
//      HwRtcEngine.setupLocalView(_viewId, widget.mode);
//    } else {
//      HwRtcEngine.setupRemoteView(
//          _viewId, widget.mode, StreamType.STREAM_TYPE_SD, widget.uid);
//    }
//  }

  @override
  Widget build(BuildContext context) => _nativeView;
}
