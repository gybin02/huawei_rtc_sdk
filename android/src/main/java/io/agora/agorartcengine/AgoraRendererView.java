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
    private final long uid;

    AgoraRendererView(SurfaceView surfaceView, int uid) {
        this.mSurfaceView = surfaceView;
        this.uid = uid;
    }

    @Override
    public View getView() {
        return mSurfaceView;
    }

    @Override
    public void dispose() {
    }
}