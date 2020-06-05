package io.agora.agorartcengine;

import android.content.Context;
import android.graphics.Rect;
import android.os.Handler;
import android.os.Looper;
import android.view.SurfaceView;

import java.util.HashMap;

import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.models.UserInfo;
import io.agora.rtc.video.VideoCanvas;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;

/**
 * 华为 RTC 引擎插件 tcEnginePlugin
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
public class AgoraRtcEnginePlugin implements MethodCallHandler, EventChannel.StreamHandler {

    private final Registrar mRegistrar;
    private static RtcEngine mRtcEngine;
    private HashMap<String, SurfaceView> mRendererViews;
    private Handler mEventHandler = new Handler(Looper.getMainLooper());
    private EventChannel.EventSink sink;

    void addView(SurfaceView view, int id) {
        mRendererViews.put("" + id, view);
    }

    private void removeView(int id) {
        mRendererViews.remove("" + id);
    }

    private SurfaceView getView(int id) {
        return mRendererViews.get("" + id);
    }

    public static RtcEngine getRtcEngine() {
        return mRtcEngine;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "agora_rtc_engine");

        final EventChannel eventChannel = new EventChannel(registrar.messenger(), "agora_rtc_engine_event_channel");

        AgoraRtcEnginePlugin plugin = new AgoraRtcEnginePlugin(registrar);
        channel.setMethodCallHandler(plugin);
        eventChannel.setStreamHandler(plugin);

        AgoraRenderViewFactory fac = new AgoraRenderViewFactory(StandardMessageCodec.INSTANCE,
                plugin);
        registrar.platformViewRegistry().registerViewFactory("AgoraRendererView", fac);
    }

    private AgoraRtcEnginePlugin(Registrar registrar) {
        this.mRegistrar = registrar;
        this.sink = null;
        this.mRendererViews = new HashMap<>();
    }

    private Context getActiveContext() {
        return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Context context = getActiveContext();

        switch (call.method) {
            // Core Methods
            case "create": {
                try {
                    String appId = call.argument("appId");
                    mRtcEngine = RtcEngine.create(context, appId, mRtcEventHandler);
                    result.success(null);
                } catch (Exception e) {
                    throw new RuntimeException("NEED TO check rtc sdk init fatal error\n");
                }
            }
            break;
            case "destroy": {
                RtcEngine.destroy();
                result.success(null);
            }
            break;
            case "joinRoom": {
                String token = call.argument("token");
                String channel = call.argument("channelId");
                String info = call.argument("info");
                int uid = call.argument("uid");
                result.success(mRtcEngine.joinChannel(token, channel, info, uid) >= 0);
            }
            break;
            case "leaveRoom": {
                result.success(mRtcEngine.leaveChannel() >= 0);
            }
            break;

            // Core Audio
            case "muteLocalAudio": {
                mRtcEngine.enableAudio();
                result.success(null);
            }
            break;

            case "setSpeakerModel":
                break;

            case "removeNativeView": {
                int viewId = call.argument("viewId");
                removeView(viewId);
                result.success(null);
            }
            break;
            case "setupLocalVideo": {
                int localViewId = call.argument("viewId");
                SurfaceView localView = getView(localViewId);
                int localRenderMode = call.argument("renderMode");
                VideoCanvas localCanvas = new VideoCanvas(localView);
                localCanvas.renderMode = localRenderMode;
                mRtcEngine.setupLocalVideo(localCanvas);
                result.success(null);
            }
            break;
            case "setupRemoteVideo": {
                int remoteViewId = call.argument("viewId");
                SurfaceView view = getView(remoteViewId);
                int remoteRenderMode = call.argument("renderMode");
                int remoteUid = call.argument("uid");
                mRtcEngine.setupRemoteVideo(new VideoCanvas(view, remoteRenderMode, remoteUid));
                result.success(null);
            }
            break;

            case "muteLocalVideo": {
                boolean enabled = call.argument("enabled");
                mRtcEngine.enableLocalVideo(enabled);
                result.success(null);
            }
            break;

            // Camera Control
            case "switchCamera": {
                mRtcEngine.switchCamera();
                result.success(null);
            }
            break;

            // Miscellaneous Methods
            case "setLogParam": {

            }
            break;

            case "setLogFilter": {
                int filter = call.argument("filter");
                mRtcEngine.setLogFilter(filter);
                result.success(null);
            }
            break;

            case "logUpload":
                break;

            default:
                result.notImplemented();
        }
    }

    private final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() {
        @Override
        public void onWarning(int warn) {
            super.onWarning(warn);
            HashMap<String, Object> map = new HashMap<>();
            map.put("warn", warn);
            sendEvent("onWarning", map);
        }

        @Override
        public void onError(int err) {
            super.onError(err);
            HashMap<String, Object> map = new HashMap<>();
            map.put("errorCode", err);
            sendEvent("onError", map);
        }

        @Override
        public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
            super.onJoinChannelSuccess(channel, uid, elapsed);
            HashMap<String, Object> map = new HashMap<>();
            map.put("channel", channel);
            map.put("uid", uid);
            map.put("elapsed", elapsed);
            sendEvent("onJoinRoomSuccess", map);
        }

        @Override
        public void onRejoinChannelSuccess(String channel, int uid, int elapsed) {

        }

        @Override
        public void onLeaveChannel(RtcStats stats) {
            super.onLeaveChannel(stats);
            HashMap<String, Object> map = new HashMap<>();
            sendEvent("onLeaveRoom", map);
        }

        @Override
        public void onClientRoleChanged(int oldRole, int newRole) {
            super.onClientRoleChanged(oldRole, newRole);

        }

        @Override
        public void onUserJoined(int uid, int elapsed) {
            super.onUserJoined(uid, elapsed);
            HashMap<String, Object> map = new HashMap<>();
            map.put("uid", uid);
            map.put("elapsed", elapsed);
            sendEvent("onUserJoined", map);
        }

        @Override
        public void onUserOffline(int uid, int reason) {
            super.onUserOffline(uid, reason);
            HashMap<String, Object> map = new HashMap<>();
            map.put("uid", uid);
            map.put("reason", reason);
            sendEvent("onUserOffline", map);
        }

        @Override
        public void onLocalUserRegistered(int uid, String userAccount) {
            super.onLocalUserRegistered(uid, userAccount);

        }

        @Override
        public void onUserInfoUpdated(int uid, UserInfo userInfo) {
            super.onUserInfoUpdated(uid, userInfo);

        }

        @Override
        public void onConnectionStateChanged(int state, int reason) {
            super.onConnectionStateChanged(state, reason);
            HashMap<String, Object> map = new HashMap<>();
            map.put("state", state);
            map.put("reason", reason);
            sendEvent("onConnectionStateChange", map);
        }

        @Override
        public void onNetworkTypeChanged(int type) {
            super.onNetworkTypeChanged(type);

        }

        @Override
        public void onConnectionLost() {
            super.onConnectionLost();
        }

        @Override
        public void onApiCallExecuted(int error, String api, String result) {
            super.onApiCallExecuted(error, api, result);

        }

        @Override
        public void onTokenPrivilegeWillExpire(String token) {
            super.onTokenPrivilegeWillExpire(token);

        }

        @Override
        public void onRequestToken() {
            super.onRequestToken();
        }

        @Override
        public void onAudioVolumeIndication(AudioVolumeInfo[] speakers, int totalVolume) {
            super.onAudioVolumeIndication(speakers, totalVolume);

        }

        @Override
        public void onActiveSpeaker(int uid) {
            super.onActiveSpeaker(uid);

        }

        @Override
        public void onFirstLocalAudioFrame(int elapsed) {
            super.onFirstLocalAudioFrame(elapsed);

        }

        @Override
        public void onFirstRemoteAudioFrame(int uid, int elapsed) {
            super.onFirstRemoteAudioFrame(uid, elapsed);

        }

        @Override
        public void onFirstRemoteAudioDecoded(int uid, int elapsed) {
            super.onFirstRemoteAudioDecoded(uid, elapsed);

        }

        @Override
        public void onFirstLocalVideoFrame(int width, int height, int elapsed) {
            super.onFirstLocalVideoFrame(width, height, elapsed);

        }

        @Override
        public void onFirstRemoteVideoFrame(int uid, int width, int height, int elapsed) {
            super.onFirstRemoteVideoFrame(uid, width, height, elapsed);
            HashMap<String, Object> map = new HashMap<>();
            map.put("uid", uid);
            map.put("width", width);
            map.put("height", height);
            map.put("elapsed", elapsed);
            sendEvent("onFirstRemoteVideoDecoded", map);
        }

        @Override
        public void onUserMuteAudio(int uid, boolean muted) {
            super.onUserMuteAudio(uid, muted);

        }


        @Override
        public void onVideoSizeChanged(int uid, int width, int height, int rotation) {
            super.onVideoSizeChanged(uid, width, height, rotation);

        }

        @Override
        public void onRemoteVideoStateChanged(int uid,
                                              int state,
                                              int reason,
                                              int elapsed) {
            super.onRemoteVideoStateChanged(uid, state, reason, elapsed);

        }

        @Override
        public void onLocalVideoStateChanged(int state, int error) {
            super.onLocalVideoStateChanged(state, error);

        }

        @Override
        public void onRemoteAudioStateChanged(int uid, int state, int reason, int elapsed) {
            super.onRemoteAudioStateChanged(uid, state, reason, elapsed);
        }

        @Override
        public void onLocalAudioStateChanged(int state, int error) {
            super.onLocalAudioStateChanged(state, error);

        }

        @Override
        public void onLocalPublishFallbackToAudioOnly(boolean isFallbackOrRecover) {
            super.onLocalPublishFallbackToAudioOnly(isFallbackOrRecover);

        }

        @Override
        public void onRemoteSubscribeFallbackToAudioOnly(int uid, boolean isFallbackOrRecover) {
            super.onRemoteSubscribeFallbackToAudioOnly(uid, isFallbackOrRecover);

        }

        @Override
        public void onAudioRouteChanged(int routing) {
            super.onAudioRouteChanged(routing);

        }

        @Override
        public void onCameraFocusAreaChanged(Rect rect) {
            super.onCameraFocusAreaChanged(rect);

        }

        @Override
        public void onCameraExposureAreaChanged(Rect rect) {
            super.onCameraExposureAreaChanged(rect);

        }

        @Override
        public void onRtcStats(RtcStats stats) {
            super.onRtcStats(stats);

        }

        @Override
        public void onLastmileQuality(int quality) {
            super.onLastmileQuality(quality);
        }

        @Override
        public void onNetworkQuality(int uid, int txQuality, int rxQuality) {
            super.onNetworkQuality(uid, txQuality, rxQuality);

        }

        @Override
        public void onLastmileProbeResult(LastmileProbeResult result) {
            super.onLastmileProbeResult(result);

        }

        @Override
        public void onLocalVideoStats(LocalVideoStats stats) {
            super.onLocalVideoStats(stats);

        }

        @Override
        public void onLocalAudioStats(LocalAudioStats stats) {
            super.onLocalAudioStats(stats);

        }

        @Override
        public void onRemoteVideoStats(RemoteVideoStats stats) {
            super.onRemoteVideoStats(stats);

        }

        @Override
        public void onRemoteAudioStats(RemoteAudioStats stats) {
            super.onRemoteAudioStats(stats);

        }

        @Override
        public void onAudioMixingStateChanged(int state, int errorCode) {

        }

        @Override
        public void onAudioEffectFinished(int soundId) {

        }

        @Override
        public void onStreamPublished(String url, int error) {

        }

        @Override
        public void onStreamUnpublished(String url) {

        }

        @Override
        public void onTranscodingUpdated() {
            super.onTranscodingUpdated();
        }

        @Override
        public void onRtmpStreamingStateChanged(String url,
                                                int state,
                                                int errCode) {
            super.onRtmpStreamingStateChanged(url, state, errCode);

        }


        @Override
        public void onStreamInjectedStatus(String url, int uid, int status) {
            super.onStreamInjectedStatus(url, uid, status);

        }

        @Override
        public void onMediaEngineLoadSuccess() {
            super.onMediaEngineLoadSuccess();
        }

        @Override
        public void onMediaEngineStartCallSuccess() {
            super.onMediaEngineStartCallSuccess();

        }

        @Override
        public void onChannelMediaRelayStateChanged(int state, int code) {
            super.onChannelMediaRelayStateChanged(state, code);

        }

        @Override
        public void onChannelMediaRelayEvent(int code) {
            super.onChannelMediaRelayEvent(code);

        }


    };


    private void sendEvent(final String eventName, final HashMap map) {
        map.put("event", eventName);
        mEventHandler.post(new Runnable() {
            @Override
            public void run() {
                if (sink != null) {
                    sink.success(map);
                }
            }
        });
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.sink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        this.sink = null;
    }

}
