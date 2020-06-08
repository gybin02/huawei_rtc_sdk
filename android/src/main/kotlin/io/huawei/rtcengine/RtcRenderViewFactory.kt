package io.huawei.rtcengine

import android.content.Context
import com.huawei.rtc.RtcEngine
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.huawei.rtcengine.HwRtcEnginePlugin

/**
 * 注册
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
class RtcRenderViewFactory(
    createArgsCodec: MessageCodec<Any?>?,
    private val mEnginePlugin: HwRtcEnginePlugin
) : PlatformViewFactory(createArgsCodec) {
    override fun create(
        context: Context,
        viewId: Int,
        args: Any
    ): PlatformView {
        val view =
            RtcEngine.createRenderer(context.applicationContext)
        val rendererView = RtcRendererView(view, viewId)
        mEnginePlugin.addView(view, viewId)
        return rendererView
    }

}