package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;
import android.text.TextUtils;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.source.UrlSource;
import com.aliyun.player.source.VidAuth;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import com.aliyun.player.source.VidSts;
import com.aliyun.player.source.VidMps;
import com.aliyun.player.VidPlayerConfigGen;
import java.util.Map;

public class VideoView implements PlatformView, MethodChannel.MethodCallHandler {

    private MethodChannel methodChannel;
    private AliPlayer mAliPlayer;
    private TextureView mTextureView;
    private String mUrl;

    VideoView(Context context, int viewId, Object args, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        mAliPlayer = AliPlayerFactory.createAliPlayer(context);
        this.methodChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),"flutter_aliplayer");
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
        System.out.println("abc : methodCall view");
        switch (methodCall.method) {
            case "setUrl":
                mUrl = methodCall.arguments.toString();
                setDataSource(mUrl);
                break;
            case "setVidSts":
                Map<String,String> stsMap = (Map<String,String>)methodCall.arguments;
                VidSts vidSts = new VidSts();
                vidSts.setRegion(stsMap.get("region"));
                vidSts.setVid(stsMap.get("vid"));
                vidSts.setAccessKeyId(stsMap.get("accessKeyId"));
                vidSts.setAccessKeySecret(stsMap.get("accessKeySecret"));
                vidSts.setSecurityToken(stsMap.get("securityToken"));

                if(stsMap.containsKey("previewTime") && !TextUtils.isEmpty(stsMap.get("previewTime"))){
                    VidPlayerConfigGen vidPlayerConfigGen = new VidPlayerConfigGen();
                    int previewTime = Integer.valueOf(stsMap.get("previewTime"));
                    vidPlayerConfigGen.setPreviewTime(previewTime);
                    vidSts.setPlayConfig(vidPlayerConfigGen);
                }
                setDataSource(vidSts);
                break;
            case "setVidAuth":
                Map<String,String> authMap = (Map<String,String>)methodCall.arguments;
                VidAuth vidAuth = new VidAuth();
                vidAuth.setVid(authMap.get("vid"));
                vidAuth.setRegion(authMap.get("region"));
                vidAuth.setPlayAuth(authMap.get("playAuth"));
                if(authMap.containsKey("previewTime") && !TextUtils.isEmpty(authMap.get("previewTime"))){
                    VidPlayerConfigGen vidPlayerConfigGen = new VidPlayerConfigGen();
                    int previewTime = Integer.valueOf(authMap.get("previewTime"));
                    vidPlayerConfigGen.setPreviewTime(previewTime);
                    vidAuth.setPlayConfig(vidPlayerConfigGen);
                }
                setDataSource(vidAuth);
                break;
            case "setVidMps":
                Map<String,String> mpsMap = (Map<String,String>)methodCall.arguments;
                VidMps vidMps = new VidMps();
                vidMps.setMediaId(mpsMap.get("vid"));
                vidMps.setRegion(mpsMap.get("region"));
                vidMps.setAccessKeyId(mpsMap.get("accessKeyId"));
                vidMps.setAccessKeySecret(mpsMap.get("accessKeySecret"));
                if(mpsMap.containsKey("playDomain") && !TextUtils.isEmpty(mpsMap.get("playDomain"))){
                    vidMps.setPlayDomain(mpsMap.get("playDomain"));
                }
                vidMps.setAuthInfo(mpsMap.get("authInfo"));
                vidMps.setHlsUriToken(mpsMap.get("hlsUriToken"));
                vidMps.setSecurityToken(mpsMap.get("securityToken"));
                setDataSource(vidMps);
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
            case "getSDKVersion":
                result.success(getSDKVersion());
                break;
            default:
                result.notImplemented();
        }
    }

    private String getSDKVersion(){
        return AliPlayerFactory.getSdkVersion();
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

    private void setDataSource(VidAuth vidAuth){
        if(mAliPlayer != null){
            mAliPlayer.setDataSource(vidAuth);
        }   
    }

    private void setDataSource(VidMps vidMps){
        if(mAliPlayer != null){
            mAliPlayer.setDataSource(vidMps);
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
