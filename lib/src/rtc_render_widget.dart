import 'dart:developer';
import 'package:flutter/material.dart';

import '../huawei_rtc_engine.dart';

/// 封装好的视频界面Widget - This widget will automatically manage the native view.
///
/// Enables create native view with `uid` `mode` `local` and destroy native view automatically.
///
class RtcRenderWidget extends StatefulWidget {
  // uid
  final String uid;

  // local flag
  final bool local;

  /// 暂时不用先保留local preview flag;
  ///
  final bool preview;

  /// render mode
  final ViewMode mode;

  RtcRenderWidget(
    this.uid, {
    this.mode = ViewMode.VIEW_MODE_CROP,
    this.local = false,
    this.preview = false,
  })  : assert(uid != null),
        assert(mode != null),
        assert(local != null),
        assert(preview != null),
        super(key: Key(uid));

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
//    AgoraRtcEngine.removeNativeView(_viewId);
    super.dispose();
  }

  @override
  void didUpdateWidget(RtcRenderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    log("widget: ${widget.uid}, oldWidget: $oldWidget");
    if ((widget.uid != oldWidget.uid && widget.local != oldWidget.local) &&
        _viewId != null) {
      _bindView();
      return;
    }

//    if (widget.mode != oldWidget.mode) {
//      _changeRenderMode();
//      return;
//    }
  }

  void _bindView() {
    if (widget.local) {
      Text("Local");
//      AgoraRtcEngine.setupLocalView(_viewId, widget.mode);
    } else {
      Text("remote");
//      AgoraRtcEngine.setupRemoteView(
//          _viewId, widget.mode, StreamType.STREAM_TYPE_SD, widget.uid);
    }
  }

  void _changeRenderMode() {
    //暂不支持
  }

  @override
  Widget build(BuildContext context) => _nativeView;
}
