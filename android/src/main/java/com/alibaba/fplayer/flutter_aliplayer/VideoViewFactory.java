package com.alibaba.fplayer.flutter_aliplayer_example;

import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class VideoViewFactory extends PlatformViewFactory {

    private FlutterPlugin.FlutterPluginBinding mFlutterPluginBinding;

    public VideoViewFactory(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        super(StandardMessageCodec.INSTANCE);
        this.mFlutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new VideoView(context,viewId,args,mFlutterPluginBinding);
    }
}
