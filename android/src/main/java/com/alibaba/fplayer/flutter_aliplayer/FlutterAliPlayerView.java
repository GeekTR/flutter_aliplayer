package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.view.TextureView;
import android.view.View;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.platform.PlatformView;


public class FlutterAliPlayerView implements PlatformView {


    private TextureView mTextureView;


    FlutterAliPlayerView(Context context, int viewId, Object args, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        initRenderView(context);
    }


    private void initRenderView(Context context){
        mTextureView = new TextureView(context);
    }

    @Override
    public View getView() {
        return mTextureView;
    }

    @Override
    public void dispose() {

    }
}
