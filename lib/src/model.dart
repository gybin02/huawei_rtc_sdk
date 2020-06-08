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
  //耳机
  AUDIO_EARPIECE,
  //外放
  AUDIO_SPEAKER,
}

///媒体类型
enum MediaType {
  ///只有音频流。
  MEDIA_TYPE_AUDIO,

  ///音频流+视频流。
  MEDIA_TYPE_AUDIO_VIDEO,

  ///数据流，暂不支持。
  MEDIA_TYPE_AUDIO_VIDEO_DATA,
}

///角色
///https://support.huaweicloud.com/csdk-rtc/rtc_05_0009.html#rtc_05_0009__section181001014124014
///
enum RoleType {
  ///双向流角色，例如主播加入。
  ROLE_TYPE_JOINER,

  ///发布流角色，例如广播
  ///
  ROLE_TYPE_PUBLISHER,

  ///接收流角色，例如观众
  ROLE_TYPE_PLAYER,
}

///用户信息跟SDK的 UserInfo对应
///
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

///rtc 内部log配置参数
///
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
