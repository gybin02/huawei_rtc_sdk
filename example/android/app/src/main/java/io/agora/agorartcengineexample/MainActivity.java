package io.agora.agorartcengineexample;

import android.os.Bundle;

import com.huawei.rtc.RtcEngine;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
/**
 * 主页面
 *
 * @author zhengxiaobin
 * @date 2020/6/11
 */
public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    RtcEngine.destroy();
  }
}
