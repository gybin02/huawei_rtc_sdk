import 'dart:developer';
import 'package:flutter/material.dart';

import '../huawei_rtc_engine.dart';

/// 封装好的视频界面Widget - This widget will automatically manage the native view.
///
/// Enables create native view with `uid` `mode` `local` and destroy native view automatically.
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
    log("initState: ${widget.uid}");
    _nativeView = HwRtcEngine.createNativeView((viewId) {
      _viewId = viewId;
      _bindView();
    });
  }

  @override
  void dispose() {
    log("dispose: ${widget.uid},  viewId： $_viewId ");
    HwRtcEngine.removeNativeView(_viewId);
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
