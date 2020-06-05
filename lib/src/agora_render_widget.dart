import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

/// 视频或者通话界面Widget - This widget will automatically manage the native view.
///
/// Enables create native view with `uid` `mode` `local` and destroy native view automatically.
///
class AgoraRenderWidget extends StatefulWidget {
  // uid
  final String uid;

  // local flag
  final bool local;

  /// 暂时不用先保留local preview flag;
  ///
  final bool preview;

  /// render mode
  final ViewMode mode;

  AgoraRenderWidget(
    this.uid, {
    this.mode = ViewMode.VIEW_MODE_ADAPT,
    this.local = false,
    this.preview = false,
  })  : assert(uid != null),
        assert(mode != null),
        assert(local != null),
        assert(preview != null),
        super(key: Key(uid.toString()));

  @override
  State<StatefulWidget> createState() => _AgoraRenderWidgetState();
}

class _AgoraRenderWidgetState extends State<AgoraRenderWidget> {
  Widget _nativeView;

  int _viewId;

  @override
  void initState() {
    super.initState();
    _nativeView = AgoraRtcEngine.createNativeView((viewId) {
      _viewId = viewId;
      _bindView();
    });
  }

  @override
  void dispose() {
    AgoraRtcEngine.removeNativeView(_viewId);
    super.dispose();
  }

  @override
  void didUpdateWidget(AgoraRenderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.uid != oldWidget.uid || widget.local != oldWidget.local) &&
        _viewId != null) {
      _bindView();
      return;
    }

    if (widget.mode != oldWidget.mode) {
      _changeRenderMode();
      return;
    }
  }

  void _bindView() {
    if (widget.local) {
      AgoraRtcEngine.setupLocalView(_viewId, widget.mode);
    } else {
      AgoraRtcEngine.setupRemoteView(_viewId, widget.mode);
    }
  }

  void _changeRenderMode() {
    //暂不支持
  }

  @override
  Widget build(BuildContext context) => _nativeView;
}
