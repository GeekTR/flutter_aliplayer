package com.alibaba.fplayer.flutter_aliplayer_example;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.os.Looper;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.source.UrlSource;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

public class VideoView implements PlatformView, MethodChannel.MethodCallHandler {

    private MethodChannel methodChannel;
    private AliPlayer mAliPlayer;
    private TextureView mTextureView;
    private String mUrl;

    VideoView(Context context, int viewId, Object args, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        mAliPlayer = AliPlayerFactory.createAliPlayer(context);
        this.methodChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),"flutter_aliplayer_"+viewId);
        this.methodChannel.setMethodCallHandler(this);
        initRenderView(context);
    }

    private void initRenderView(Context context){
        mTextureView = new TextureView(context);
        mTextureView.setSurfaceTextureListener(new TextureView.SurfaceTextureListener() {
            @Override
            public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
               Surface mSurface = new Surface(surface);
               if(mAliPlayer != null){
                   mAliPlayer.setSurface(mSurface);
               }
            }

            @Override
            public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
                if(mAliPlayer != null){
                    mAliPlayer.surfaceChanged();
                }
            }

            @Override
            public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
                return false;
            }

            @Override
            public void onSurfaceTextureUpdated(SurfaceTexture surface) {

            }
        });
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "setUrl":
                mUrl = methodCall.arguments.toString();
                break;
            case "prepare":
                UrlSource urlSource = new UrlSource();
                urlSource.setUri(mUrl);
                mAliPlayer.setDataSource(urlSource);
                mAliPlayer.setAutoPlay(true);
                mAliPlayer.prepare();
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public View getView() {
        return mTextureView;
    }

    @Override
    public void dispose() { }
}
