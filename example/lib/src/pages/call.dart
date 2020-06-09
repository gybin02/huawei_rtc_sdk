import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/huawei_rtc_engine.dart';
import 'package:agora_rtc_engine_example/src/widget/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/settings.dart';
///通话页面
///
class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String roomId;

  final String userId;
  final RoleType roleType;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.roomId, this.userId, this.roleType})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <String>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool mutedVideo = false;
  bool isSpeaker = false;

  @override
  void dispose() {
    // clear users
//    _users.clear();
    HwRtcEngine.leaveRoom();
    // destroy sdk
//    HwRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
    _users.add(widget.userId);
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initHwRtcEngine();
    _addEventHandlers();
    UserInfo userInfo = new UserInfo();
    userInfo.userId = widget.userId;
    userInfo.userName = widget.userId;
    userInfo.role = widget.roleType.index;
    var ret = await HwRtcEngine.joinRoom(
        userInfo, widget.roomId, MediaType.MEDIA_TYPE_AUDIO_VIDEO);
    log("joinRoom ret: $ret");
  }

  /// Create agora sdk instance and initialize
  Future<void> _initHwRtcEngine() async {
    await HwRtcEngine.create(APP_DOMAIN, APP_ID);
  }

  /// Add agora event handlers
  void _addEventHandlers() {
    HwRtcEngine.onError = (int error, String msg) {
      setState(() {
        final info = 'onError: $error: $msg';
        _infoStrings.add(info);
      });
    };

    HwRtcEngine.onJoinRoomSuccess = (
      String roomId,
      String uid,
    ) {
      log("onJoinRoomSuccess $roomId:$uid");
      setState(() {
        final info = 'onJoinRoomSuccess: $roomId, uid: $uid';
        _infoStrings.add(info);
      });
    };

    HwRtcEngine.onLeaveRoom = (String roomId, String userId) {
      log('userId:$userId onLeaveRoom: room:$roomId');
//      setState(() {
//        _infoStrings.add('userId:$userId onLeaveRoom: room:$roomId');
//        _users.clear();
//      });
    };

    HwRtcEngine.onUserJoined = (String roomId, String userId, String nickName) {
      setState(() {
        var info =
            "onUserJoined roomId: $roomId userId:$userId nickname:$nickName, widget.uid:${widget.userId}";
        if (userId != null && widget.userId == userId) {
//          widget.roleType == RoleType.ROLE_TYPE_PUBLISER
          return;
        }
        _infoStrings.add(info);
        _users.add(userId);
      });
    };

    HwRtcEngine.onUserOffline = (String roomId, String userId, int reason) {
      setState(() {
        final info = 'userOffline: $userId, roomId:$roomId';
        _infoStrings.add(info);
        _users.remove(userId);
      });
    };

    HwRtcEngine.onFirstRemoteVideoDecoded =
        (String roomId, String userId, int width, int height) {
      setState(() {
        final info =
            'room:$roomId onFirstRemoteVideoDecoded: user:$userId ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    List<RtcRenderWidget> list = [];
    _users.forEach((String uid) {
      if (uid == widget.userId) {
        list.add(RtcRenderWidget(
          uid,
          local: true,
        ));
      } else {
        list.add(RtcRenderWidget(uid));
      }
    });
    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>((view) {
      return expanded(view);
    }).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Expanded expanded(Widget view) {
    return Expanded(
      flex: view == null ? 0 : 1,
      child: view == null ? Container() : view,
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
//    return Column(children: views,);
    var length = views.length;
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              expanded(views[0]),
              expanded(length > 1 ? views[1] : null),
            ],
          ),
        ),
        Expanded(
          flex: length > 2 ? 1 : 0,
          child: Row(
            children: <Widget>[
              expanded(length > 2 ? views[2] : null),
              expanded(length > 3 ? views[3] : null),
            ],
          ),
        )
      ],
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _toggleBtn(_onToggleMute, muted, Icons.mic_off, Icons.mic),
          _toggleBtn(
              _toggleMuteVideo, mutedVideo, Icons.videocam_off, Icons.videocam),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            constraints: BoxConstraints.tightFor(),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          _toggleBtn(_toggleSpeakerModel, isSpeaker, Icons.volume_up,
              Icons.volume_off),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            constraints: BoxConstraints.tightFor(),
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  Widget _toggleBtn(
      Function onPressed, bool value, IconData trueIcon, IconData falseIcon) {
    return RawMaterialButton(
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(),
      child: Icon(
        value ? trueIcon : falseIcon,
        color: value ? Colors.white : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: value ? Colors.blueAccent : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  int _temp = 0;

  //本地禁音
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    HwRtcEngine.muteLocalAudio(muted);
  }

  void testAdd(){
    setState(() {
      ++_temp;
      _users.add("_temp $_temp");
    });
  }

  //关闭本地视频
  void _toggleMuteVideo() {
    setState(() {
      mutedVideo = !mutedVideo;
    });
    HwRtcEngine.muteLocalVideo(mutedVideo);
  }

  void _toggleSpeakerModel() {
    setState(() {
      isSpeaker = !isSpeaker;
    });
    HwRtcEngine.setSpeakerModel(
        isSpeaker ? SpeakerModel.AUDIO_SPEAKER : SpeakerModel.AUDIO_EARPIECE);
  }

  void _onSwitchCamera() {
    HwRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rtc Flutter QuickStart'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
