# HuaweiRtcEngine

这个是[Huawei RTC SDK](https://support.huaweicloud.com/demo-rtc/rtc_03_0001.html) 的Flutter封装。

实时互动直播SDK：提供直播和实时音视频流传输（收发双向）的能力。

## 功能：
- 音视频通话

 支持一对多，多对多的视频互动直播。

- 直播

连麦互动，主播加入频道时，即可实现连麦互动，观众可在直播的任一时刻切换为主播，与频道内现有主播进行连麦互动。

## 使用
### 1. 引入库：
```
huawei_rtc_engine
    git: http://techgit.meitu.com/flutter/huawei_rtc
```
## 2.使用
以下所有方法都封装在 **HwRtcEngine** 中

### 1. 创建引擎
```dart
await HwRtcEngine.create(APP_DOMAIN, APP_ID);
```
### 2. 加入房间
```dart
await HwRtcEngine.joinRoom(
      userInfo, roomId, MediaType.MEDIA_TYPE_AUDIO_VIDEO);
```

### 3. 监听房间
```
//其他用户加入
 static void Function(String roomId, String userId, String nickName)
      onUserJoined;
//其他用户退出
  static void Function(String roomId, String userId, int reason) onUserOffline;

```

### 4. 退出房间
```
  static Future<int> leaveRoom() async
```

### 5. 销毁引擎
```dart
  static Future<void> destroy() async 
```
### 6. 获取视频播放控件
视频播放流已经封装成widget控件，方便在任意界面使用

```
   RtcRenderWidget(
    this.uid, {
    this.mode = ViewMode.VIEW_MODE_ADAPT,
    this.local = false,
    this.preview = false,
  })

```

### 7. 构建通话界面
参考： example里面的 call.dart 页面

![s1](/screen/screen1.jpg)
![s2](/screen/screen2.jpg)


### 8. 更多功能
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

##  注意事项
- 进入房间前需要先检测下是否有 相机权限和SD卡权限

### 代办
1. 调用 engine.destroy()会触发：F/eitu.rtcexampl( 2224): indirect_reference_table.cc:61] JNI ERROR (app bug): accessed deleted Global 0x2856

## 引用

- 构建你的第一个Flutter视频通话应用 https://segmentfault.com/a/1190000018247461
- https://github.com/AgoraIO-Community/Agora-Flutter-WebRTC-QuickStart
- https://pub.dev/packages/agora_rtc_wrapper
- [RTMP、WebRTC、UDP 三种互动直播方案的优劣比较](https://www.sohu.com/a/228379721_827544)
- [互动直播的技术细节和解决方案实践经验谈](https://www.cnblogs.com/zhangxiaoliu/archive/2017/03/20/6586575.html)
- flutter中增加PlatformView https://www.jianshu.com/p/75ee04e64b28
- Flutter Platform View 使用及原理简析 https://blog.csdn.net/QiwooMobile/article/details/99287723
- 5分钟彻底搞懂Flutter中PlatFormView与Texture https://cloud.tencent.com/developer/article/1584477
- 在Flutter中嵌入Native组件的正确姿势是...https://www.cnblogs.com/yunqishequ/p/9968123.html
- 通过共享内存优化flutter外接纹理的渲染性能，实时渲染不是梦 http://www.luoyibu.cn/posts/9703/
- [Flutter 实现视频全屏播放逻辑及解析](https://zhuanlan.zhihu.com/p/107556856)