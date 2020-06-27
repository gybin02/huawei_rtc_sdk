import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/model.dart';

export 'src/rtc_render_widget.dart';
export 'src/model.dart';

///华为RTC引擎库
class HwRtcEngine {
  static const MethodChannel _channel =
      const MethodChannel('huawei_rtc_engine');
  static const EventChannel _eventChannel =
      const EventChannel('huawei_rtc_engine_event_channel');

  static StreamSubscription<dynamic> _sink;

  /// Core Methods
  /// Creates an RtcEngine instance.
  ///
  ///使用[domain]和[appId]和创建实例
  static Future<void> create(String domain, String appId) async {
    await _channel.invokeMethod('create', {'domain': domain, 'appId': appId});
    _addEventChannelHandler();
  }

  /// Destroys the RtcEngine instance and releases all resources
  ///
  /// This method is useful for apps that occasionally make voice or video calls, to free up resources for other operations when not making calls.
  /// Once the app calls destroy to destroy the created RtcEngine instance, you cannot use any method or callback in the SDK.
  static Future<void> destroy() async {
    await _removeEventChannelHandler();
    await _channel.invokeMethod('destroy');
  }

  /// Allows a user to join a channel.
  ///
  /// Users in the same channel can talk to each other, and multiple users in the same channel can start a group chat. Users with different App IDs cannot call each other.
  /// You must call the [leaveRoom] method to exit the current call before joining another channel.
  /// A channel does not accept duplicate uids, such as two users with the same uid. If you set uid as 0, the system automatically assigns a uid.
  static Future<int> joinRoom(
      UserInfo userInfo, String roomId, MediaType mediaType) async {
    return await _channel.invokeMethod('joinRoom', {
      'userInfo': userInfo.toJson(),
      'roomId': roomId,
      'mediaType': mediaType.index
    });
  }

  /// Allows a user to leave a Room.
  ///
  /// If you call the [destroy] method immediately after calling this method, the leaveRoom process interrupts, and the SDK does not trigger the onleaveRoom callback.
  static Future<int> leaveRoom() async {
    return await _channel.invokeMethod('leaveRoom');
  }

  /// Core Audio
  /// 设置本地麦克风静音。
  ///
  static Future<int> muteLocalAudio(bool mute) async {
    return await _channel.invokeMethod('muteLocalAudio', {"mute": mute});
  }

  // Core Video
  /// 关闭/打开本地摄像头。
  ///
  static Future<int> muteLocalVideo(bool mute) async {
    return await _channel.invokeMethod('muteLocalVideo', {"mute": mute});
  }

  /// Creates the video renderer Widget.
  ///
  /// The Widget is identified by viewId, the operation and layout of the Widget are managed by the app.
  static Widget createNativeView(Function(int viewId) created, {Key key}) {
    if (Platform.isIOS) {
      return UiKitView(
        key: key,
        viewType: 'HuaweiRendererView',
        onPlatformViewCreated: (viewId) {
          if (created != null) {
            created(viewId);
          }
        },
      );
    } else {
      return AndroidView(
        key: key,
        viewType: 'HuaweiRendererView',
        onPlatformViewCreated: (viewId) {
          if (created != null) {
            created(viewId);
          }
        },
      );
    }
  }

  /// Remove the video renderer Widget.
  static Future<void> removeNativeView(int viewId) async {
    await _channel.invokeMethod('removeNativeView', {'viewId': viewId});
  }

  /// Sets the local video view and configures the video display settings on the local device.
  ///
  /// 设置本地摄像头视频流页面
  /// You can call this method to bind local video streams to Widget created by [createNativeView] of the  and configure the video display settings.
  static Future<int> setupLocalView(int viewId, ViewMode viewMode) async {
    return await _channel.invokeMethod(
        'setupLocalView', {'viewId': viewId, 'viewMode': viewMode.index});
  }

  /// Sets the remote user's video view. 设置远端视频流界面
  ///
  /// This method binds the remote user to the Widget created by [createNativeView].
  static Future<int> setupRemoteView(int viewId, ViewMode viewMode,
      StreamType streamType, String userId) async {
    return await _channel.invokeMethod('setupRemoteView', {
      'viewId': viewId,
      'viewMode': viewMode.index,
      'streamType': streamType.index,
      'userId': userId
    });
  }

  /// 设置声音播放模式。
  static Future<int> setSpeakerModel(SpeakerModel speakerModel) async {
    return await _channel
        .invokeMethod('setSpeakerModel', {'speakerModel': speakerModel.index});
  }

  // Camera Control
  /// Switches between front and rear cameras.
  static Future<int> switchCamera() async {
    return await _channel.invokeMethod('switchCamera');
  }

  /// Miscellaneous Methods
  /// 上传华为SDK日志
  static Future<int> logUpload() async {
    return await _channel.invokeMethod('logUpload');
  }

  ///设置日志参数
  ///
  static Future<int> setLogParam(bool enable, LogInfo logInfo) async {
    return await _channel.invokeMethod('setLogParam', {
      "enable": enable,
      "logInfo": logInfo,
    });
  }

//////////// End //////////////

  static void _addEventChannelHandler() async {
    _sink = _eventChannel.receiveBroadcastStream().listen(_eventListener,
        onError: (error) {
      log(error);
    });
  }

  static void _removeEventChannelHandler() async {
    await _sink.cancel();
  }

  // CallHandler
  static void _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    log("sendEvent: $map");
    switch (map['event']) {
      // Core Events
      case 'onWarning':
        if (onWarning != null) {
          onWarning(map['warn'], map["msg"]);
        }
        break;
      case 'onError':
        if (onError != null) {
          onError(map['error'], map["msg"]);
        }
        break;
      case 'onJoinRoomSuccess':
        if (onJoinRoomSuccess != null) {
          onJoinRoomSuccess(map['roomId'], map['userId']);
        }
        break;
      case 'onLeaveRoom':
        if (onLeaveRoom != null) {
          onLeaveRoom(map["roomId"], map["userId"]);
        }
        break;

      case 'onUserJoined':
        if (onUserJoined != null) {
          onUserJoined(map['roomId'], map['userId'], map["nickName"]);
        }
        break;
      case 'onUserOffline':
        if (onUserOffline != null) {
          onUserOffline(map['roomId'], map['userId'], map["reason"]);
        }
        break;

      case 'onConnectionStateChanged':
        if (onConnectionStateChange != null) {
          int connStateTypes = map["connStateTypes"];
          int connChangeReason = map["connChangeReason"];
          String description = map["description"];

          onConnectionStateChange(ConnStateTypes.values[connStateTypes],
              ConnChangeReason.values[connChangeReason], description);
        }
        break;

      // Media Events
      case 'onFirstRemoteVideoDecoded':
        if (onFirstRemoteVideoDecoded != null) {
          onFirstRemoteVideoDecoded(
              map["roomId"], map['userId'], map['width'], map["height"]);
        }
        break;

      // Miscellaneous Events
      case 'onLogUploadResult':
        if (onLogUploadResult != null) {
          onLogUploadResult(map["result"]);
        }
        break;
      case 'onLogUploadProgress':
        if (onLogUploadProgress != null) {
          onLogUploadProgress(map["progress"]);
        }
        break;
      case 'onAgreedStreamAvailable':
        if (onAgreedStreamAvailable != null) {
          int streamType = map["streamType"];
          onAgreedStreamAvailable(
              map["roomId"], map["userId"], StreamType.values[streamType]);
        }
        break;

      default:
    }
  }

  // Core Events
  /// Reports a warning during SDK runtime.
  ///
  /// In most cases, the app can ignore the warning reported by the SDK because the SDK can usually fix the issue and resume running.
  static void Function(int warn, String msg) onWarning;

  /// Reports an error during SDK runtime.
  ///
  /// In most cases, the SDK cannot fix the issue and resume running. The SDK requires the app to take action or informs the user about the issue.
  static void Function(int error, String msg) onError;

  /// Occurs when a user joins a specified channel.
  ///
  /// The channel name assignment is based on channelName specified in the [joinRoom] method.
  /// If the uid is not specified when [joinRoom] is called, the server automatically assigns a uid.
  static void Function(String roomId, String uid) onJoinRoomSuccess;

  /// Occurs when a user leaves the channel.
  ///
  /// When the app calls the [leaveRoom] method, the SDK uses this callback to notify the app when the user leaves the channel.
  static void Function(String roomId, String userId) onLeaveRoom;

  /// Occurs when a remote user (Communication)/host (Live Broadcast) joins the channel.
  ///
  /// Communication profile: This callback notifies the app when another user joins the channel. If other users are already in the channel, the SDK also reports to the app on the existing users.
  static void Function(String roomId, String userId, String nickName)
      onUserJoined;

  /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves the channel.
  ///用户下线的时候触发，
  static void Function(String roomId, String userId, int reason) onUserOffline;

  /// Occurs when the network connection state changes.
  /// 当网络状态变更的时候触发
  static void Function(
      ConnStateTypes connStateTypes,
      ConnChangeReason connChangeReason,
      String description) onConnectionStateChange;

  /// Occurs when the first remote audio frame is received.
  ///视频开始解析的时候触发
  static void Function(String roomId, String userId, int width, int height)
      onFirstRemoteVideoDecoded;

  ///日志上传回调
  static void Function(int result) onLogUploadResult;
  ///日志上传进度回调
  static void Function(int progress) onLogUploadProgress;
  ///默认流时回调，获取到默认流。
  static void Function(String roomId, String userId, StreamType streamType)
      onAgreedStreamAvailable;
}
