# HuaweiRtcEngine

这个是[Huawei RTC SDK](https://support.huaweicloud.com/demo-rtc/rtc_03_0001.html) 的Flutter封装。

实时互动直播SDK：提供连麦和实时音视频流传输（收发双向）的能力，设置最基本的连麦等功能。


## 使用

### 1. 创建引擎
```dart
static Future<void> create(String domain, String appId)
```
### 2. 加入房间
```dart
  static Future<int> joinRoom(
      UserInfo userInfo, String roomId, MediaType mediaType)

```

### 3. 监听房间
```
 static void Function(String roomId, String userId, String nickName)
      onUserJoined;

  /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves the channel.
  ///
  /// There are two reasons for users to become offline:
  /// 1. Leave the channel: When the user/host leaves the channel, the user/host sends a goodbye message. When this message is received, the SDK determines that the user/host leaves the channel.
  /// 2. Drop offline: When no data packet of the user or host is received for a certain period of time (20 seconds for the communication profile, and more for the live broadcast profile), the SDK assumes that the user/host drops offline. A poor network connection may lead to false detections, so Agora recommends using the signaling system for reliable offline detection.
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
```
 static Widget createNativeView(Function(int viewId) created, {Key key}) 
 
 //已经封装成更上层的
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

```

### Android 注意事项

- 进入房间前需要先检测下是否有 相机权限和SD卡权限

### iOS


### Release crash


### 引用

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



