package io.huawei.rtcengine

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.SurfaceView
import com.huawei.rtc.IRtcEngineEventHandler
import com.huawei.rtc.RtcEngine
import com.huawei.rtc.models.LogInfo
import com.huawei.rtc.models.LogInfo.LogLevel
import com.huawei.rtc.models.StatsInfo
import com.huawei.rtc.utils.RtcEnums
import com.huawei.rtc.utils.RtcEnums.ConnChangeReason
import com.huawei.rtc.utils.RtcEnums.ConnStateTypes
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.StandardMessageCodec
import java.util.*

/**
 * 华为 RTC 引擎插件 tcEnginePlugin
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
class HwRtcEnginePlugin private constructor(private val mRegistrar: Registrar) :
    MethodCallHandler,
    EventChannel.StreamHandler {
    private val mRendererViews: HashMap<String, SurfaceView> = HashMap()
    private val mEventHandler =
        Handler(Looper.getMainLooper())
    private var sink: EventSink? = null

    fun addView(view: SurfaceView, id: Int) {
        mRendererViews["" + id] = view
    }

    private fun removeView(id: Int) {
        mRendererViews.remove("" + id)
    }

    private fun getView(id: Int): SurfaceView? {
        return mRendererViews["" + id]
    }

    private val activeContext: Context
        get() = if (mRegistrar.activity() != null) mRegistrar.activity() else mRegistrar.context()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val context = activeContext
        var argument = ""
        if (call.arguments != null) {
            argument = call.arguments.toString()
        }
        Log.d(
            TAG,
            "onMethodCall: method: " + call.method + "   argument: " + argument
        )
        when (call.method) {
            "create" -> {
                try {
                    val appId = call.argument<String>("appId")
                    val domain = call.argument<String>("domain")
                    setEngine(RtcEngine.create(context, domain, appId, mRtcEventHandler))
                    result.success(null)
                } catch (e: Exception) {
                    throw RuntimeException("NEED TO check rtc sdk init fatal error\n")
                }
            }
            "destroy" -> {
                try {
                    RtcEngine.destroy()
                    result.success(null)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
            "joinRoom" -> {
                val roomId = call.argument<String>("roomId")
                val userInfoJson =
                    call.argument<Map<String, Any>>("userInfo")!!
                val userInfo = RtcUtil.userInfoFromJson(userInfoJson)
                val mediaType = call.argument<Int>("mediaType")!!
                result.success(
                    rtcEngine!!.joinRoom(
                        userInfo,
                        roomId,
                        RtcEnums.MediaType.values()[mediaType]
                    )
                )
            }
            "leaveRoom" -> {
                result.success(rtcEngine!!.leaveRoom())
            }
            "muteLocalAudio" -> {
                val mute = call.argument<Boolean>("mute")!!
                result.success(rtcEngine!!.muteLocalAudio(mute))
            }
            "setSpeakerModel" -> {
                val speakerModel = call.argument<Int>("speakerModel")!!
                result.success(
                    rtcEngine!!.setSpeakerModel(
                        RtcEnums.SpeakerModel.values()[speakerModel]
                    )
                )
            }
            "removeNativeView" -> {
                val viewId = call.argument<Int>("viewId")!!
                removeView(viewId)
                result.success(null)
            }
            "setupLocalView" -> {
                val localViewId = call.argument<Int>("viewId")!!
                val localView = getView(localViewId)
                val viewMode = call.argument<Int>("viewMode")!!
                val setupLocalView = rtcEngine!!.setupLocalView(
                    localView,
                    RtcEnums.ViewMode.values()[viewMode]
                )
                Log.e(
                    TAG,
                    "onMethodCall: setupLocalView: ret: $setupLocalView"
                )
                result.success(setupLocalView)
            }
            "setupRemoteView" -> {
                val remoteViewId = call.argument<Int>("viewId")!!
                val view = getView(remoteViewId)
                val viewMode = call.argument<Int>("viewMode")!!
                val userId = call.argument<String>("userId")
                val streamType = call.argument<Int>("streamType")!!
                val setupRemoteView =
                    rtcEngine!!.setupRemoteView(
                        view,
                        RtcEnums.ViewMode.values()[viewMode],
                        RtcEnums.StreamType.values()[streamType],
                        userId
                    )
                Log.e(
                    TAG,
                    "onMethodCall: setupRemoteView: ret: $setupRemoteView"
                )
                result.success(setupRemoteView)
            }
            "muteLocalVideo" -> {
                val mute = call.argument<Boolean>("mute")!!
                result.success(rtcEngine!!.muteLocalVideo(mute))
            }
            "switchCamera" -> {
                result.success(rtcEngine!!.switchCamera())
            }
            "setLogParam" -> {
                val enable = call.argument<Boolean>("enable")!!
                val logInfoMap =
                    call.argument<Map<String?, *>>("logInfo")!!
                val logInfo = RtcUtil.logInfoFromJson(logInfoMap)
                result.success(RtcEngine.setLogParam(enable, logInfo))
            }
            "logUpload" -> result.success(rtcEngine!!.logUpload())
            else -> result.notImplemented()
        }
    }

    private val mRtcEventHandler: IRtcEngineEventHandler = object : IRtcEngineEventHandler {
        override fun onWarning(warn: Int, msg: String) {
            val map =
                HashMap<String, Any>()
            map["warn"] = warn
            map["msg"] = msg
            sendEvent("onWarning", map)
        }

        override fun onError(err: Int, msg: String) {
            val map =
                HashMap<String, Any>()
            map["errorCode"] = err
            map["msg"] = msg
            sendEvent("onError", map)
        }

        override fun onJoinRoomSuccess(
            roomId: String,
            userId: String
        ) {
            val map =
                HashMap<String, Any>()
            map["roomId"] = roomId
            map["userId"] = userId
            sendEvent("onJoinRoomSuccess", map)
        }

        override fun onLeaveRoom(
            roomId: String,
            userId: String,
            stats: StatsInfo
        ) {
            val map =
                HashMap<String, Any>()
            map["roomId"] = roomId
            map["userId"] = userId
            sendEvent("onLeaveRoom", map)
        }

        override fun onUserJoined(
            roomId: String,
            userId: String,
            nickName: String
        ) {
            val map =
                HashMap<String, Any>()
            map["userId"] = userId
            map["roomId"] = roomId
            map["nickName"] = nickName
            sendEvent("onUserJoined", map)
        }

        override fun onUserOffline(
            roomId: String,
            userId: String,
            reason: Int
        ) {
            val map =
                HashMap<String, Any>()
            map["roomId"] = roomId
            map["userId"] = userId
            map["reason"] = reason
            sendEvent("onUserOffline", map)
        }

        override fun onConnectionStateChange(
            connStateTypes: ConnStateTypes,
            connChangeReason: ConnChangeReason,
            description: String
        ) {
            val map =
                HashMap<String, Any>()
            map["connStateTypes"] = connStateTypes.ordinal
            map["connChangeReason"] = connChangeReason.ordinal
            map["description"] = description
            sendEvent("onConnectionStateChange", map)
        }

        override fun onLogUploadResult(result: Int) {
            val map =
                HashMap<String, Any>()
            map["result"] = result
            sendEvent("onLogUploadResult", map)
        }

        override fun onLogUploadProgress(progress: Int) {
            val map =
                HashMap<String, Any>()
            map["progress"] = progress
            sendEvent("onLogUploadProgress", map)
        }

        override fun onAgreedStreamAvailable(
            roomId: String,
            userId: String,
            streamType: RtcEnums.StreamType
        ) {
            val map =
                HashMap<String, Any>()
            map["roomId"] = roomId
            map["userId"] = userId
            map["streamType"] = streamType.ordinal
            sendEvent("onAgreedStreamAvailable", map)
        }

        override fun onFirstRemoteVideoDecoded(
            roomId: String,
            userId: String,
            width: Int,
            height: Int
        ) {
            val map =
                HashMap<String, Any>()
            map["roomId"] = roomId
            map["userId"] = userId
            map["width"] = width
            map["height"] = height
            sendEvent("onFirstRemoteVideoDecoded", map)
        }
    }

    private fun sendEvent(eventName: String, map: HashMap<String, Any>) {
        map["event"] = eventName
        Log.d(
            TAG,
            "sendEvent: $eventName  params: $map"
        )
        mEventHandler.post {
            sink?.success(map)
        }
    }

    override fun onListen(arguments: Any?, eventSink: EventSink?) {
        sink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    companion object {
        private const val TAG = "HwRtcEnginePlugin"
        var rtcEngine: RtcEngine? = null
            private set

        /**
         * Plugin registration.
         */
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "agora_rtc_engine")
            val eventChannel =
                EventChannel(registrar.messenger(), "agora_rtc_engine_event_channel")
            val plugin = HwRtcEnginePlugin(registrar)
            channel.setMethodCallHandler(plugin)
            eventChannel.setStreamHandler(plugin)
            val fac = RtcRenderViewFactory(
                StandardMessageCodec.INSTANCE,
                plugin
            )
            registrar.platformViewRegistry().registerViewFactory("AgoraRendererView", fac)
        }

        private fun setEngine(mRtcEngine: RtcEngine) {
            if (rtcEngine == null) {
                rtcEngine = mRtcEngine
                val logInfo = LogInfo()
                logInfo.level = LogLevel.LOG_LEVEL_DEBUG
                logInfo.path = RtcUtil.logPath
                RtcEngine.setLogParam(false, logInfo)
            }
        }
    }

}