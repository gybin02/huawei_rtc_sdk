package io.agora.agorartcengine

import android.view.SurfaceView
import android.view.View
import io.flutter.plugin.platform.PlatformView

/**
 * 封装SurfaceView 给Flutter
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
class AgoraRendererView internal constructor(
    private val mSurfaceView: SurfaceView,
    private val viewId: Int
) :
    PlatformView {
    override fun getView(): View {
        return mSurfaceView
    }

    override fun dispose() {}

}