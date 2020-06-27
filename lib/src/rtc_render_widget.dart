import 'dart:developer';
import 'package:flutter/material.dart';

import '../huawei_rtc_engine.dart';

/// 封装好的视频通话界面Widget - This widget will automatically manage the native view.
///
/// 注意：dispose 中会销毁NativeView。因此上层构建布局的时候要注意dispose的调用，避免触发dispose。
///
/// 这种布局会导致dispose
///witch (views.length) {
//      case 1:
//        return Container(
//            child: Column(
//              children: <Widget>[_videoView(views[0])],
//            ));
//      case 2:
//        return Container(
//            child: Column(
//              children: <Widget>[
//                _expandedVideoRow([views[0]]),
//                _expandedVideoRow([views[1]])
//              ],
//            ));
///
class RtcRenderWidget extends StatefulWidget {
  /// uid
  final String uid;

  /// local flag
  final bool local;

  /// render mode
  final ViewMode mode;

  RtcRenderWidget(this.uid, {
    Key key,
    this.mode = ViewMode.VIEW_MODE_PAD,
    this.local = false,
  });

  @override
  State<StatefulWidget> createState() => _RtcRenderWidgetState();
}

class _RtcRenderWidgetState extends State<RtcRenderWidget> {
  Widget _nativeView;
  int _viewId;

  @override
  void initState() {
    super.initState();
//    log("initState: ${widget.uid}");
    _nativeView = HwRtcEngine.createNativeView((viewId) {
      _viewId = viewId;
      _bindView();
    });
  }

  @override
  void dispose() {
//    log("dispose: ${widget.uid},  viewId： $_viewId ");
    HwRtcEngine.removeNativeView(_viewId);
    super.dispose();
  }

  void _bindView() {
    if (widget.local) {
      HwRtcEngine.setupLocalView(_viewId, widget.mode);
    } else {
      HwRtcEngine.setupRemoteView(
          _viewId, widget.mode, StreamType.STREAM_TYPE_SD, widget.uid);
    }
  }

  @override
  Widget build(BuildContext context) => _nativeView;
}
