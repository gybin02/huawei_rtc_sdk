# HuaweiRtcEngine

这个是[Huawei RTC SDK](https://support.huaweicloud.com/demo-rtc/rtc_03_0001.html) 的Flutter封装。

实时互动直播SDK：提供连麦和实时音视频流传输（收发双向）的能力。

## 功能：
- 视频通话 支持一对多，多对多的视频互动直播。

- 直播连麦互动 主播加入频道时，即可实现连麦互动，观众可在直播的任一时刻切换为主播，与频道内现有主播进行连麦互动。

## 使用


### Android

打开 *AndroidManifest.xml* file，加入需要的权限

```xml
..
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

```

### iOS


### Release crash

