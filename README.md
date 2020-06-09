# HuaweiRtcEngine

这个是[Huawei RTC SDK](https://support.huaweicloud.com/demo-rtc/rtc_03_0001.html) 的Flutter封装。

实时互动直播SDK：提供连麦和实时音视频流传输（收发双向）的能力。

## 功能：
- 视频通话 支持一对多，多对多的视频互动直播。

- 直播连麦互动 主播加入频道时，即可实现连麦互动，观众可在直播的任一时刻切换为主播，与频道内现有主播进行连麦互动。

## 使用
### 1. 引入库：
```
agora_rtc_engine_example
git: http://techgit.meitu.com/flutter/huawei_rtc
```
### 2.初始化
```dart
//初始化引擎
await HwRtcEngine.create(APP_DOMAIN, APP_ID);
//构建视频布局：
RtcRenderWidget(uid);

//done

```


### 3. 构建通话界面
参考： example里面的 call.dart 页面

### 4. 更多功能
```yaml
create
createNativeView
destroy
joinRoom
leaveRoom
logUpload
muteLocalAudio
muteLocalVideo
removeNativeView
setLogParam
setSpeakerModel
setupLocalView
setupRemoteView
switchCamera

//通知回调
onAgreedStreamAvailable
onConnectionStateChange
onError
onFirstRemoteVideoDecoded
onJoinRoomSuccess
onLeaveRoom
onLogUploadProgress
onLogUploadResult
onUserJoined
onUserOffline
onWarning

```

### Android 注意事项

### iOS 注意事项


### TODO
1. 调用 engine.destroy()会触发：F/eitu.rtcexampl( 2224): indirect_reference_table.cc:61] JNI ERROR (app bug): accessed deleted Global 0x2856


