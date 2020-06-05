package io.agora.agorartcengine;

import android.content.Context;
import android.graphics.Rect;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.SurfaceView;

import com.huawei.rtc.IRtcEngineEventHandler;
import com.huawei.rtc.RtcEngine;
import com.huawei.rtc.models.LogInfo;
import com.huawei.rtc.models.StatsInfo;
import com.huawei.rtc.models.UserInfo;
import com.huawei.rtc.utils.RtcEnums;

import java.util.HashMap;
import java.util.Map;

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
    private static String TAG = "AgoraRtcEnginePlugin";

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
        String argument = "";
        if (call.arguments != null) {
            argument = call.arguments.toString();
        }
        Log.d(TAG, "onMethodCall: method: " + call.method + "   argument: " + argument);
        switch (call.method) {
            // Core Methods
            case "create": {
                try {
                    String appId = call.argument("appId");
                    String domain = call.argument("domain");
                    mRtcEngine = RtcEngine.create(context, domain, appId, mRtcEventHandler);
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
                String roomId = call.argument("roomId");
                Map<String, Object> userInfoJson = call.argument("userInfo");
                UserInfo userInfo = RtcUtil.userInfoFromJson(userInfoJson);

                int mediaType = call.argument("mediaType");
                result.success(mRtcEngine.joinRoom(userInfo, roomId, RtcEnums.MediaType.values()[mediaType]));
            }
            break;
            case "leaveRoom": {
                result.success(mRtcEngine.leaveRoom());
            }
            break;

            // Core Audio
            case "muteLocalAudio": {
                boolean mute = call.argument("mute");
                result.success(mRtcEngine.muteLocalAudio(mute));
            }
            break;

            case "setSpeakerModel":
                int speakerModel = call.argument("speakerModel");
                result.success(mRtcEngine.setSpeakerModel(RtcEnums.SpeakerModel.values()[speakerModel]));
                break;

//            case "createRenderer":
//                SurfaceView surfaceView = mRtcEngine.createRenderer(context);
//
//                break;
            case "removeNativeView": {
                int viewId = call.argument("viewId");
                removeView(viewId);
                result.success(null);
            }
            break;
            case "setupLocalView": {
                int localViewId = call.argument("viewId");
                SurfaceView localView = getView(localViewId);
                int viewMode = call.argument("viewMode");
                int setupLocalView = mRtcEngine.setupLocalView(localView, RtcEnums.ViewMode.values()[viewMode]);
                result.success(setupLocalView);
            }
            break;
            case "setupRemoteView": {
                int remoteViewId = call.argument("viewId");
                SurfaceView view = getView(remoteViewId);
                int viewMode = call.argument("viewMode");
                String userId = call.argument("userId");
                int streamType = call.argument("streamType");

                int setupRemoteView = mRtcEngine.setupRemoteView(view, RtcEnums.ViewMode.values()[viewMode], RtcEnums.StreamType.values()[streamType], userId);
                result.success(setupRemoteView);
            }
            break;

            case "muteLocalVideo": {
                boolean mute = call.argument("mute");
                result.success(mRtcEngine.muteLocalVideo(mute));
            }
            break;

            // Camera Control
            case "switchCamera": {
                result.success(mRtcEngine.switchCamera());
            }
            break;

            // Miscellaneous Methods
            case "setLogParam": {
                boolean enable = call.argument("enable");
                Map logInfoMap = call.argument("logInfo");
                LogInfo logInfo = RtcUtil.logInfoFromJson(logInfoMap);
                result.success(RtcEngine.setLogParam(enable, logInfo));
            }
            break;
            case "logUpload":
                result.success(mRtcEngine.logUpload());
                break;
            default:
                result.notImplemented();
        }
    }

    private final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() {

        @Override
        public void onWarning(int warn, String msg) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("warn", warn);
            map.put("msg", msg);
            sendEvent("onWarning", map);
        }

        @Override
        public void onError(int err, String msg) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("errorCode", err);
            map.put("msg", msg);
            sendEvent("onError", map);
        }

        @Override
        public void onJoinRoomSuccess(String roomId, String userId) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("roomId", roomId);
            map.put("userId", userId);
            sendEvent("onJoinRoomSuccess", map);
        }


        @Override
        public void onLeaveRoom(String roomId, String userId, StatsInfo stats) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("roomId", roomId);
            map.put("userId", userId);
            sendEvent("onLeaveRoom", map);
        }


        @Override
        public void onUserJoined(String roomId, String userId, String nickName) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("uid", userId);
            map.put("roomId", roomId);
            map.put("nickName", nickName);
            sendEvent("onUserJoined", map);
        }

        @Override
        public void onUserOffline(String roomId, String userId, int reason) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("roomId", roomId);
            map.put("userId", userId);
            map.put("reason", reason);
            sendEvent("onUserOffline", map);
        }


        @Override
        public void onConnectionStateChange(RtcEnums.ConnStateTypes connStateTypes, RtcEnums.ConnChangeReason connChangeReason, String description) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("connStateTypes", connStateTypes.ordinal());
            map.put("connChangeReason", connChangeReason.ordinal());
            map.put("description", description);
            sendEvent("onConnectionStateChange", map);
        }

        @Override
        public void onLogUploadResult(int result) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("result", result);
            sendEvent("onLogUploadResult", map);
        }

        @Override
        public void onLogUploadProgress(int progress) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("progress", progress);
            sendEvent("onLogUploadProgress", map);
        }

        @Override
        public void onAgreedStreamAvailable(String roomId, String userId, RtcEnums.StreamType streamType) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("roomId", roomId);
            map.put("userId", userId);
            map.put("streamType", streamType.ordinal());
            sendEvent("onAgreedStreamAvailable", map);
        }


        @Override
        public void onFirstRemoteVideoDecoded(String roomId, String userId, int width, int height) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("roomId", roomId);
            map.put("userId", userId);
            map.put("width", width);
            map.put("height", height);
            sendEvent("onFirstRemoteVideoDecoded", map);
        }


    };


    private void sendEvent(final String eventName, final HashMap map) {
        map.put("event", eventName);
        Log.d(TAG, "sendEvent: " + eventName + "  params: " + map.toString());
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
