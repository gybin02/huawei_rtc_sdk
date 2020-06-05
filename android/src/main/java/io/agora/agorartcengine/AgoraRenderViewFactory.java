package io.agora.agorartcengine;

import android.content.Context;
import android.view.SurfaceView;

import com.huawei.rtc.RtcEngine;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * 注册
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
public class AgoraRenderViewFactory extends PlatformViewFactory {
    private final AgoraRtcEnginePlugin mEnginePlugin;

    public AgoraRenderViewFactory(MessageCodec<Object> createArgsCodec, AgoraRtcEnginePlugin enginePlugin) {
        super(createArgsCodec);
        this.mEnginePlugin = enginePlugin;
    }


    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        SurfaceView view = RtcEngine.createRenderer(context.getApplicationContext());
        AgoraRendererView rendererView = new AgoraRendererView(view, viewId);
        mEnginePlugin.addView(view, viewId);
        return rendererView;
    }
}