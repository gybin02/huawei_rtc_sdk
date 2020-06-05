package io.agora.agorartcengine;

import android.view.SurfaceView;
import android.view.View;

import io.flutter.plugin.platform.PlatformView;

/**
 * 封装SurfaceView 给Flutter
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
public class AgoraRendererView implements PlatformView {
    private final SurfaceView mSurfaceView;
    private final int viewId;

    AgoraRendererView(SurfaceView surfaceView, int viewId) {
        this.mSurfaceView = surfaceView;
        this.viewId = viewId;
    }

    @Override
    public View getView() {
        return mSurfaceView;
    }

    @Override
    public void dispose() {
    }
}