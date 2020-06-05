import 'dart:ui';

class AgoraImage {
  String url;
  int x;
  int y;
  int width;
  int height;

  AgoraImage(this.url, this.x, this.y, this.width, this.height);

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

  @override
  String toString() {
    return "{x: $x, y: $y, width: $width, height: $height}";
  }
}

class AgoraLiveTranscodingUser {
  String uid;
  int width;
  int height;
  int x;
  int y;
  int zOrder;
  int alpha;
  int audioChannel;

  AgoraLiveTranscodingUser.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'],
        width = json['width'],
        height = json['height'],
        x = json['x'],
        y = json['y'],
        zOrder = json['zOrder'],
        alpha = json['alpha'],
        audioChannel = json['audioChannel'];

  Map<dynamic, dynamic> toJson() => {
        'uid': uid,
        'width': width,
        'height': height,
        'x': x,
        'y': y,
        'zOrder': zOrder,
        'alpha': alpha,
        'audioChannel': audioChannel
      };
}

enum AgoraAudioCodecProfileType { LCAAC, HEAAC }

enum AgoraVideoCodecProfileType { BaseLine, Main, High }

enum AgoraAudioSampleRateType { LowRateType, MidRateType, HighRateType }

Map<AgoraAudioSampleRateType, int> _resolveAudioSampleRate = {
  AgoraAudioSampleRateType.LowRateType: 32000,
  AgoraAudioSampleRateType.MidRateType: 44100,
  AgoraAudioSampleRateType.HighRateType: 48000
};

class AgoraLiveInjectStreamConfig {
  int width;
  int height;
  int videoGop;
  int videoFramerate;
  int videoBitrate;
  int audioBitrate;
  AgoraAudioSampleRateType audioSampleRate;

  AgoraLiveInjectStreamConfig.fromJson(Map<dynamic, dynamic> json)
      : width = json['width'],
        height = json['height'],
        videoGop = json['videoGop'],
        videoFramerate = json['videoFramerate'],
        videoBitrate = json['videoBitrate'],
        audioBitrate = json['audioBitrate'],
        audioSampleRate = json['audioSampleRate'];

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'videoGop': videoGop,
        'videoFramerate': videoFramerate,
        'videoBitrate': videoBitrate,
        'audioBitrate': audioBitrate,
        'audioSampleRate': _resolveAudioSampleRate[audioSampleRate],
      };

  @override
  String toString() {
    return "{width: $width, height: $height, videoGop: $videoGop, videoFramerate: $videoFramerate, videoBitrate: $videoBitrate, audioBitrate: $audioBitrate, audioSampleRate: ${_resolveAudioSampleRate[audioSampleRate]}}";
  }
}

class AudioVolumeInfo {
  String uid;
  int volume;

  AudioVolumeInfo(String uid, int volume) {
    this.uid = uid;
    this.volume = volume;
  }
}

class RtcStats {
  final int totalDuration;
  final int txBytes;
  final int rxBytes;
  final int txAudioBytes;
  final int txVideoBytes;
  final int rxAudioBytes;
  final int rxVideoBytes;
  final int txKBitrate;
  final int rxKBitrate;
  final int txAudioKBitrate;
  final int rxAudioKBitrate;
  final int txVideoKBitrate;
  final int rxVideoKBitrate;
  final int lastmileDelay;
  final int txPacketLossRate;
  final int rxPacketLossRate;
  final int users;
  final double cpuTotalUsage;
  final double cpuAppUsage;

  RtcStats(
    this.totalDuration,
    this.txBytes,
    this.rxBytes,
    this.txAudioBytes,
    this.txVideoBytes,
    this.rxAudioBytes,
    this.rxVideoBytes,
    this.txKBitrate,
    this.rxKBitrate,
    this.txAudioKBitrate,
    this.rxAudioKBitrate,
    this.txVideoKBitrate,
    this.rxVideoKBitrate,
    this.lastmileDelay,
    this.txPacketLossRate,
    this.rxPacketLossRate,
    this.users,
    this.cpuTotalUsage,
    this.cpuAppUsage,
  );

  RtcStats.fromJson(Map<dynamic, dynamic> json)
      : totalDuration = json['totalDuration'],
        txBytes = json['txBytes'],
        rxBytes = json['rxBytes'],
        txAudioBytes = json['txAudioBytes'],
        txVideoBytes = json['txVideoBytes'],
        rxAudioBytes = json['rxAudioBytes'],
        rxVideoBytes = json['rxVideoBytes'],
        txKBitrate = json['txKBitrate'],
        rxKBitrate = json['rxKBitrate'],
        txAudioKBitrate = json['txAudioKBitrate'],
        rxAudioKBitrate = json['rxAudioKBitrate'],
        txVideoKBitrate = json['txVideoKBitrate'],
        rxVideoKBitrate = json['rxVideoKBitrate'],
        lastmileDelay = json['lastmileDelay'],
        txPacketLossRate = json['txPacketLossRate'],
        rxPacketLossRate = json['rxPacketLossRate'],
        users = json['users'],
        cpuTotalUsage = json['cpuTotalUsage'],
        cpuAppUsage = json['cpuAppUsage'];

  Map<String, dynamic> toJson() {
    return {
      "totalDuration": totalDuration,
      "txBytes": txBytes,
      "rxBytes": rxBytes,
      "txAudioBytes": txAudioBytes,
      "txVideoBytes": txVideoBytes,
      "rxAudioBytes": rxAudioBytes,
      "rxVideoBytes": rxVideoBytes,
      "txKBitrate": txKBitrate,
      "rxKBitrate": rxKBitrate,
      "txAudioKBitrate": txAudioKBitrate,
      "rxAudioKBitrate": rxAudioKBitrate,
      "txVideoKBitrate": txVideoKBitrate,
      "rxVideoKBitrate": rxVideoKBitrate,
      "lastmileDelay": lastmileDelay,
      "txPacketLossRate": txPacketLossRate,
      "rxPacketLossRate": rxPacketLossRate,
      "users": users,
      "cpuTotalUsage": cpuTotalUsage,
      "cpuAppUsage": cpuAppUsage,
    };
  }
}

class LocalVideoStats {
  final int sentBitrate;
  final int sentFrameRate;
  final int encoderOutputFrameRate;
  final int rendererOutputFrameRate;
  final int sentTargetBitrate;
  final int sentTargetFrameRate;
  final int qualityAdaptIndication;
  final int encodedBitrate;
  final int encodedFrameWidth;
  final int encodedFrameHeight;
  final int encodedFrameCount;
  final int codecType;

  LocalVideoStats(
      this.sentBitrate,
      this.sentFrameRate,
      this.encoderOutputFrameRate,
      this.rendererOutputFrameRate,
      this.sentTargetBitrate,
      this.sentTargetFrameRate,
      this.qualityAdaptIndication,
      this.encodedBitrate,
      this.encodedFrameWidth,
      this.encodedFrameHeight,
      this.encodedFrameCount,
      this.codecType);

  LocalVideoStats.fromJson(Map<dynamic, dynamic> json)
      : sentBitrate = json["sentBitrate"],
        sentFrameRate = json["sentFrameRate"],
        encoderOutputFrameRate = json["encoderOutputFrameRate"],
        rendererOutputFrameRate = json["rendererOutputFrameRate"],
        sentTargetBitrate = json["sentTargetBitrate"],
        sentTargetFrameRate = json["sentTargetFrameRate"],
        qualityAdaptIndication = json["qualityAdaptIndication"],
        encodedBitrate = json["encodedBitrate"],
        encodedFrameWidth = json["encodedFrameWidth"],
        encodedFrameHeight = json["encodedFrameHeight"],
        encodedFrameCount = json["encodedFrameCount"],
        codecType = json["codecType"];

  Map<String, dynamic> toJson() {
    return {
      "sentBitrate": sentBitrate,
      "sentFrameRate": sentFrameRate,
      "encoderOutputFrameRate": encoderOutputFrameRate,
      "rendererOutputFrameRate": rendererOutputFrameRate,
      "sentTargetBitrate": sentTargetBitrate,
      "sentTargetFrameRate": sentTargetFrameRate,
      "qualityAdaptIndication": qualityAdaptIndication,
      "encodedBitrate": encodedBitrate,
      "encodedFrameWidth": encodedFrameWidth,
      "encodedFrameHeight": encodedFrameHeight,
      "encodedFrameCount": encodedFrameCount,
      "codecType": codecType,
    };
  }
}

class LocalAudioStats {
  final int numChannels;
  final int sentSampleRate;
  final int sentBitrate;

  LocalAudioStats(this.numChannels, this.sentSampleRate, this.sentBitrate);

  LocalAudioStats.fromJson(Map<dynamic, dynamic> json)
      : numChannels = json['numChannels'],
        sentSampleRate = json['sentSampleRate'],
        sentBitrate = json['sentBitrate'];
}

class RemoteVideoStats {
  final String uid;
  final int width;
  final int height;
  final int receivedBitrate;
  final int decoderOutputFrameRate;
  final int rendererOutputFrameRate;
  final int packetLostRate;
  final int rxStreamType;
  final int totalFrozenTime;
  final int frozenRate;

  RemoteVideoStats(
      this.uid,
      this.width,
      this.height,
      this.receivedBitrate,
      this.decoderOutputFrameRate,
      this.rendererOutputFrameRate,
      this.packetLostRate,
      this.rxStreamType,
      this.totalFrozenTime,
      this.frozenRate);

  RemoteVideoStats.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'],
        width = json['width'],
        height = json['height'],
        receivedBitrate = json['receivedBitrate'],
        decoderOutputFrameRate = json['decoderOutputFrameRate'],
        rendererOutputFrameRate = json['rendererOutputFrameRate'],
        packetLostRate = json['packetLostRate'],
        rxStreamType = json['rxStreamType'],
        totalFrozenTime = json['totalFrozenTime'],
        frozenRate = json['frozenRate'];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "width": width,
      "height": height,
      "receivedBitrate": receivedBitrate,
      "decoderOutputFrameRate": decoderOutputFrameRate,
      "rendererOutputFrameRate": rendererOutputFrameRate,
      "packetLostRate": packetLostRate,
      "rxStreamType": rxStreamType,
      "totalFrozenTime": totalFrozenTime,
      "frozenRate": frozenRate,
    };
  }
}

class RemoteAudioStats {
  String uid;
  int quality;
  int networkTransportDelay;
  int jitterBufferDelay;
  int audioLossRate;
  int numChannels;
  int receivedSampleRate;
  int receivedBitrate;
  int totalFrozenTime;
  int frozenRate;

  RemoteAudioStats(
    this.uid,
    this.quality,
    this.networkTransportDelay,
    this.jitterBufferDelay,
    this.audioLossRate,
    this.numChannels,
    this.receivedSampleRate,
    this.receivedBitrate,
    this.totalFrozenTime,
    this.frozenRate,
  );

  RemoteAudioStats.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'],
        quality = json['quality'],
        networkTransportDelay = json['networkTransportDelay'],
        jitterBufferDelay = json['jitterBufferDelay'],
        audioLossRate = json['audioLossRate'],
        numChannels = json['numChannels'],
        receivedSampleRate = json['receivedSampleRate'],
        receivedBitrate = json['receivedBitrate'],
        totalFrozenTime = json['totalFrozenTime'],
        frozenRate = json['frozenRate'];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "quality": quality,
      "networkTransportDelay": networkTransportDelay,
      "jitterBufferDelay": jitterBufferDelay,
      "audioLossRate": audioLossRate,
      "numChannels": numChannels,
      "receivedSampleRate": receivedSampleRate,
      "receivedBitrate": receivedBitrate,
      "totalFrozenTime": totalFrozenTime,
      "frozenRate": frozenRate
    };
  }
}

/// The image enhancement options in [AgoraRtcEngine.setBeautyEffectOptions].
class BeautyOptions {
  /// The lightening contrast level.
  ///
  /// 0: low contrast level.
  /// 1: (default) normal contrast level.
  /// 2: high contrast level.
  LighteningContrastLevel lighteningContrastLevel =
      LighteningContrastLevel.Normal;

  /// The brightness level.
  ///
  /// The value ranges from 0.0 (original) to 1.0.
  double lighteningLevel = 0;

  /// The sharpness level.
  ///
  ///The value ranges from 0.0 (original) to 1.0. This parameter is usually used to remove blemishes.
  double smoothnessLevel = 0;

  /// The redness level.
  ///
  /// The value ranges from 0.0 (original) to 1.0. This parameter adjusts the red saturation level.
  double rednessLevel = 0;

  Map<String, double> toJson() {
    return {
      "lighteningContrastLevel": lighteningContrastLevel.index.toDouble(),
      "lighteningLevel": lighteningLevel,
      "smoothnessLevel": smoothnessLevel,
      "rednessLevel": rednessLevel,
    };
  }
}

/// Properties of the video encoder configuration.
class VideoEncoderConfiguration {
  /// The video frame dimension used to specify the video quality in the total number of pixels along a frame's width and height.
  ///
  /// The dimension does not specify the orientation mode of the output ratio. For how to set the video orientation, see [VideoOutputOrientationMode].
  /// Whether 720p can be supported depends on the device. If the device cannot support 720p, the frame rate will be lower than the one listed in the table. Agora optimizes the video in lower-end devices.
  Size dimensions = Size(640, 360);

  /// The frame rate of the video (fps).
  ///
  /// We do not recommend setting this to a value greater than 30.
  int frameRate = 15;

  /// The minimum video encoder frame rate (fps).
  ///
  /// The default value (-1) means the SDK uses the lowest encoder frame rate.
  int minFrameRate = -1;

  /// The bitrate of the video.
  ///
  /// Sets the video bitrate (Kbps). If you set a bitrate beyond the proper range, the SDK automatically adjusts it to a value within the range. You can also choose from the following options:
  ///  - Standard: (recommended) In this mode, the bitrates differ between the Live-broadcast and Communication profiles:
  ///   - Communication profile: the video bitrate is the same as the base bitrate.
  ///   - Live-broadcast profile: the video bitrate is twice the base bitrate.
  ///  - Compatible: In this mode, the bitrate stays the same regardless of the profile. In the Live-broadcast profile, if you choose this mode, the video frame rate may be lower than the set value.
  /// Agora uses different video codecs for different profiles to optimize the user experience. For example, the Communication profile prioritizes the smoothness while the Live-broadcast profile prioritizes the video quality (a higher bitrate). Therefore, Agora recommends setting this parameter as AgoraVideoBitrateStandard.
  int bitrate = AgoraVideoBitrateStandard;

  /// The minimum encoding bitrate.
  ///
  /// The Agora SDK automatically adjusts the encoding bitrate to adapt to network conditions.
  /// Using a value greater than the default value forces the video encoder to output high-quality images but may cause more packet loss and hence sacrifice the smoothness of the video transmission.
  /// Unless you have special requirements for image quality, Agora does not recommend changing this value.
  int minBitrate = -1;

  /// The video orientation mode of the video.
  VideoOutputOrientationMode orientationMode =
      VideoOutputOrientationMode.Adaptative;

  /// The video encoding degradation preference under limited bandwidth.
  DegradationPreference degradationPreference =
      DegradationPreference.MaintainQuality;

  Map<String, dynamic> toJson() {
    return {
      'width': dimensions.width.toInt(),
      'height': dimensions.height.toInt(),
      'frameRate': frameRate,
      'minFrameRate': minFrameRate,
      'bitrate': bitrate,
      'minBitrate': minBitrate,
      'orientationMode': orientationMode.index,
      'degradationPreference': degradationPreference.index,
    };
  }
}

const int AgoraVideoBitrateStandard = 0;
const int AgoraVideoBitrateCompatible = -1;

enum ChannelProfile {
  /// This is used in one-on-one or group calls, where all users in the channel can talk freely.
  Communication,

  /// Host and audience roles that can be set by calling the [AgoraRtcEngine.setClientRole] method. The host sends and receives voice/video, while the audience can only receive voice/video.
  LiveBroadcasting,
}

enum ClientRole {
  Broadcaster,
  Audience,
}

enum VideoOutputOrientationMode {
  /// Adaptive mode.
  ///
  /// The video encoder adapts to the orientation mode of the video input device. When you use a custom video source, the output video from the encoder inherits the orientation of the original video.
  /// If the width of the captured video from the SDK is greater than the height, the encoder sends the video in landscape mode. The encoder also sends the rotational information of the video, and the receiver uses the rotational information to rotate the received video.
  /// If the original video is in portrait mode, the output video from the encoder is also in portrait mode. The encoder also sends the rotational information of the video to the receiver.
  Adaptative,

  /// Landscape mode.
  ///
  /// The video encoder always sends the video in landscape mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.
  FixedLandscape,

  /// Portrait mode.
  ///
  /// The video encoder always sends the video in portrait mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.
  FixedPortrait,
}

/// The video encoding degradation preference under limited bandwidth.
enum DegradationPreference {
  /// Degrades the frame rate to guarantee the video quality.
  MaintainQuality,

  /// Degrades the video quality to guarantee the frame rate.
  MaintainFramerate,

  /// Reserved for future use.
  Balanced,
}

enum VideoRenderMode {
  /// Uniformly scale the video until it fills the visible boundaries (cropped). One dimension of the video may have clipped contents.
  Hidden,

  /// Uniformly scale the video until one of its dimension fits the boundary (zoomed to fit). Areas that are not filled due to the disparity in the aspect ratio are filled with black.
  Fit,
}

enum LighteningContrastLevel {
  /// Low contrast level.
  Low,

  /// Normal contrast level.
  Normal,

  ///High contrast level.
  High,
}

enum LocalVideoStreamState {
  /// The local video is in the initial state.
  Stopped,

  /// The local video capturer starts successfully.
  Capturing,

  /// The first local video frame encodes successfully.
  Encoding,

  /// The local video fails to start.
  Failed,
}

enum LocalVideoStreamError {
  /// The local video is normal.
  OK,

  /// No specified reason for the local video failure.
  Failure,

  /// No permission to use the local video device.
  DeviceNoPermission,

  /// The local video capturer is in use.
  DeviceBusy,

  /// The local video capture fails. Check whether the capturer is working properly.
  CaptureFailure,

  /// The local video encoding fails.
  EncodeFailure,
}

///连接状态： https://support.huaweicloud.com/csdk-rtc/rtc_05_0005.html#rtc_05_0005__section1863519517324
///
enum ConnChangeReason {
  RTC_CONN_CHANGED_CONNECTING,
  RTC_CONN_CHANGED_JOIN_SUCCESS,
  RTC_CONN_CHANGED_RECONNECTING,
  RTC_CONN_CHANGED_RECONNECT_SUCCESS,
  RTC_CONN_CHANGED_JOIN_FAILED,
  RTC_CONN_CHANGED_RECONNCET_FAILED,
  RTC_CONN_CHANGED_INTERRUPTED,
  RTC_CONN_CHANGED_BANNED_BY_SERVER,
  RTC_CONN_CHANGED_KEEP_ALIVE_TIMEOUT,
  RTC_CONN_CHANGED_LEAVE_ROOM,
  RTC_CONN_CHANGED_JOIN_SERVER_ERROR,
  RTC_CONN_CHANGED_SFU_BREAKDOWN,
  RTC_CONN_CHANGED_USER_HAS_LOGINED,
  RTC_CONN_CHANGED_SESSIOIN_EXPIRED,
  RTC_CONN_CHANGED_AUTH_FAILED,
  RTC_CONN_CHANGED_SERVICE_UNREACHABLE,
  RTC_CONN_CHANGED_AUTH_RETRY,
  RTC_CONN_CHANGED_URL_NOT_RIGHT,
  RTC_CONN_CHANGED_AUTH_CLOCK_SYNC,
}

enum ConnStateTypes {
  RTC_CONNE_DISCONNECT,
  RTC_CONNE_CONNECTING,
  RTC_CONNE_CONNECTED,
  RTC_CONNE_RECONNETING,
  RTC_CONNE_STATE_FAILED,
}

enum ViewMode {
  VIEW_MODE_PAD,
  VIEW_MODE_CROP,
  VIEW_MODE_ADAPT,
}

enum StreamType {
  STREAM_TYPE_SD,
  STREAM_TYPE_HD,
}

enum SpeakerModel {
  AUDIO_EARPIECE,
  AUDIO_SPEAKER,
}

enum MediaType {
  MEDIA_TYPE_AUDIO,
  MEDIA_TYPE_AUDIO_VIDEO,
  MEDIA_TYPE_AUDIO_VIDEO_DATA,
}

enum RoleType {
  ROLE_TYPE_JOINER,
  ROLE_TYPE_PUBLISER,
  ROLE_TYPE_PLAYER,
}

class UserInfo {
  String userId = "";
  String userName = "";
  int ctime = 0;
  String signature = "";
  int role = RoleType.ROLE_TYPE_JOINER.index;
  String optionalInfo = "";

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "ctime": ctime,
      "signature": signature,
      "role": role,
      "optionalInfo": optionalInfo,
    };
  }
}

class LogInfo {
  ///查看[LogLevel].index
  int level;
  String path;

  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "path": path,
    };
  }
}

enum LogLevel {
  LOG_LEVEL_ERROR,
  LOG_LEVEL_WARNING,
  LOG_LEVEL_INFO,
  LOG_LEVEL_DEBUG,
}
