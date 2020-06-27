package io.huawei.rtcengine

import android.view.SurfaceView
import android.view.View
import io.flutter.plugin.platform.PlatformView

/**
 * 封装视频通话播放页面[SurfaceView] 给Flutter,方便简单构建通话页面
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
class RtcRendererView internal constructor(
    private val mSurfaceView: SurfaceView,
    private val viewId: Int
) :
    PlatformView {
    override fun getView(): View {
        return mSurfaceView
    }

    override fun dispose() {}

}