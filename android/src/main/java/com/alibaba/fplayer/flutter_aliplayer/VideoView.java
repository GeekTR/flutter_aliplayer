package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.os.Looper;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;
import android.text.TextUtils;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.source.UrlSource;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;
import com.aliyun.player.source.VidSts;
import com.aliyun.player.VidPlayerConfigGen;
import java.util.Map;

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
                if(mAliPlayer != null){
                    mAliPlayer.setSurface(null);
                }
                return false;
            }

            @Override
            public void onSurfaceTextureUpdated(SurfaceTexture surface) {

            }
        });
    }

    @Override
    public View getView() {
        return mTextureView;
    }

    @Override
    public void dispose() { }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "setUrl":
                mUrl = methodCall.arguments.toString();
                setDataSource(mUrl);
                break;
            case "setVidSts":
                Map<String,String> map = (Map<String,String>)methodCall.arguments;
                VidSts vidSts = new VidSts();
                vidSts.setRegion(map.get("region"));
                vidSts.setVid(map.get("vid"));
                vidSts.setAccessKeyId(map.get("accessKeyId"));
                vidSts.setAccessKeySecret(map.get("accessKeySecret"));
                vidSts.setSecurityToken(map.get("securityToken"));

                if(map.containsKey("previewTime") && !TextUtils.isEmpty(map.get("previewTime"))){
                    VidPlayerConfigGen vidPlayerConfigGen = new VidPlayerConfigGen();
                    int previewTime = Integer.valueOf(map.get("previewTime"));
                    vidPlayerConfigGen.setPreviewTime(previewTime);
                    vidSts.setPlayConfig(vidPlayerConfigGen);
                }
                setDataSource(vidSts);
                break;
            case "prepare":
                prepare();
                break;
            case "play":
                start();
                break;
            case "pause":
                pause();
                break;
            case "stop":
                stop();
                break;
            case "setLoop":
                setLoop((Boolean)methodCall.arguments);
                break;
            case "isLoop":

                break;
            case "setAutoPlay":
                setAutoPlay((Boolean)methodCall.arguments);
                break;
            case "setMuted":
                break;
            case "setEnableHardwareDecoder":
                
                break;
            default:
                result.notImplemented();
        }
    }

    private void setDataSource(String url){
        if(mAliPlayer != null){
            UrlSource urlSource = new UrlSource();
            urlSource.setUri(mUrl);
            mAliPlayer.setDataSource(urlSource);
        }
    }

    private void setDataSource(VidSts vidSts){
        if(mAliPlayer != null){
            mAliPlayer.setDataSource(vidSts);
        }
    }

    private void prepare(){
        if(mAliPlayer != null){
            mAliPlayer.prepare();
        }
    }

    private void start(){
        if(mAliPlayer != null){
            mAliPlayer.start();
        }
    }

    private void pause(){
        if(mAliPlayer != null){
            mAliPlayer.pause();
        }
    }

    private void stop(){
        if(mAliPlayer != null){
            mAliPlayer.stop();
        }
    }

    private void setLoop(Boolean isLoop){
        if(mAliPlayer != null){
            mAliPlayer.setLoop(isLoop);
        }
    }

    private void setAutoPlay(Boolean isAutoPlay){
        if(mAliPlayer != null){
            mAliPlayer.setAutoPlay(isAutoPlay);
        }
    }
}
