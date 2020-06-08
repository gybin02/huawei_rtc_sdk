package io.agora.agorartcengine

import android.content.Context
import com.huawei.rtc.RtcEngine
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * 注册
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
class AgoraRenderViewFactory(
    createArgsCodec: MessageCodec<Any?>?,
    private val mEnginePlugin: AgoraRtcEnginePlugin
) : PlatformViewFactory(createArgsCodec) {
    override fun create(
        context: Context,
        viewId: Int,
        args: Any
    ): PlatformView {
        val view =
            RtcEngine.createRenderer(context.applicationContext)
        val rendererView = AgoraRendererView(view, viewId)
        mEnginePlugin.addView(view, viewId)
        return rendererView
    }

}