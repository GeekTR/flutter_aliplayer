package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;
import android.text.TextUtils;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.IPlayer;
import com.aliyun.player.nativeclass.PlayerConfig;
import com.aliyun.player.source.UrlSource;
import com.aliyun.player.source.VidAuth;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import com.aliyun.player.source.VidSts;
import com.aliyun.player.source.VidMps;
import com.aliyun.player.VidPlayerConfigGen;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.Map;
import java.util.Set;

public class VideoView implements PlatformView, MethodChannel.MethodCallHandler {

    private MethodChannel methodChannel;
    private AliPlayer mAliPlayer;
    private TextureView mTextureView;
    private String mUrl;
    private final Gson mGson;

    VideoView(Context context, int viewId, Object args, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        mAliPlayer = AliPlayerFactory.createAliPlayer(context);
        this.methodChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),"flutter_aliplayer");
        this.methodChannel.setMethodCallHandler(this);
        mGson = new Gson();
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
                result.success(isLoop());
                break;
            case "setAutoPlay":
                setAutoPlay((Boolean)methodCall.arguments);
                break;
            case "setMuted":
                setMuted((Boolean)methodCall.arguments);
                break;
            case "setEnableHardwareDecoder":
                
                break;
            case "setScalingMode":
                setScaleMode((Integer) methodCall.arguments);
                break;
            case "getScalingMode":
                result.success(getScaleMode());
                break;
            case "setMirrorMode":
                setMirrorMode((Integer) methodCall.arguments);
                break;
            case "getMirrorMode":
                result.success(getMirrorMode());
                break;
            case "setRotateMode":
                setRotateMode((Integer) methodCall.arguments);
                break;
            case "getRotateMode":
                result.success(getRotateMode());
                break;
            case "setRate":
                setSpeed((Double) methodCall.arguments);
                break;
            case "getRate":
                result.success(getSpeed());
                break;
            case "setVideoBackgroundColor":
                setVideoBackgroundColor((Integer) methodCall.arguments);
                break;
            case "setVolume":
                setVolume((Double) methodCall.arguments);
                break;
            case "getVolume":
                result.success(getVolume());
                break;
            case "setConfig":
            {
                Map<String,Object> setConfigMap = (Map<String, Object>) methodCall.arguments;
                PlayerConfig config = getConfig();
                if(config != null){
                    String configJson = mGson.toJson(setConfigMap);
                    config = mGson.fromJson(configJson,PlayerConfig.class);
                    setConfig(config);
                }
            }
                break;
            case "getConfig":
                PlayerConfig config = getConfig();
                String json = mGson.toJson(config);
                Map<String,Object> configMap = mGson.fromJson(json,Map.class);
                result.success(configMap);
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

    private Boolean isLoop(){
        return mAliPlayer != null && mAliPlayer.isLoop();
    }

    private void setAutoPlay(Boolean isAutoPlay){
        if(mAliPlayer != null){
            mAliPlayer.setAutoPlay(isAutoPlay);
        }
    }

    private void setMuted(Boolean muted){
        if(mAliPlayer != null){
            mAliPlayer.setMute(muted);
        }
    }

    private void setScaleMode(int model){
        if(mAliPlayer != null){
            IPlayer.ScaleMode mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT;
            if(model == IPlayer.ScaleMode.SCALE_ASPECT_FIT.getValue()){
                mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT;
            }else if(model == IPlayer.ScaleMode.SCALE_ASPECT_FILL.getValue()){
                mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FILL;
            }else if(model == IPlayer.ScaleMode.SCALE_TO_FILL.getValue()){
                mScaleMode = IPlayer.ScaleMode.SCALE_TO_FILL;
            }
            mAliPlayer.setScaleMode(mScaleMode);
        }
    }

    private int getScaleMode(){
        int scaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT.getValue();
        if (mAliPlayer != null) {
            scaleMode =  mAliPlayer.getScaleMode().getValue();
        }
        return scaleMode;
    }

    private void setMirrorMode(int mirrorMode){
        if(mAliPlayer != null){
            IPlayer.MirrorMode mMirrorMode;
            if(mirrorMode == IPlayer.MirrorMode.MIRROR_MODE_HORIZONTAL.getValue()){
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_HORIZONTAL;
            }else if(mirrorMode == IPlayer.MirrorMode.MIRROR_MODE_VERTICAL.getValue()){
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_VERTICAL;
            }else{
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_NONE;
            }
            mAliPlayer.setMirrorMode(mMirrorMode);
        }
    }

    private int getMirrorMode(){
        int mirrorMode = IPlayer.MirrorMode.MIRROR_MODE_NONE.getValue();
        if (mAliPlayer != null) {
            mirrorMode = mAliPlayer.getMirrorMode().getValue();
        }
        return mirrorMode;
    }

    private void setRotateMode(int rotateMode){
        if(mAliPlayer != null){
            IPlayer.RotateMode mRotateMode;
            if(rotateMode == IPlayer.RotateMode.ROTATE_90.getValue()){
                mRotateMode = IPlayer.RotateMode.ROTATE_90;
            }else if(rotateMode == IPlayer.RotateMode.ROTATE_180.getValue()){
                mRotateMode = IPlayer.RotateMode.ROTATE_180;
            }else if(rotateMode == IPlayer.RotateMode.ROTATE_270.getValue()){
                mRotateMode = IPlayer.RotateMode.ROTATE_270;
            }else{
                mRotateMode = IPlayer.RotateMode.ROTATE_0;
            }
            mAliPlayer.setRotateMode(mRotateMode);
        }
    }

    private int getRotateMode(){
        int rotateMode = IPlayer.RotateMode.ROTATE_0.getValue();
        if(mAliPlayer != null){
            rotateMode =  mAliPlayer.getRotateMode().getValue();
        }
        return rotateMode;
    }

    private void setSpeed(double speed){
        if(mAliPlayer != null){
            mAliPlayer.setSpeed((float) speed);
        }
    }

    private double getSpeed(){
        double speed = 0;
        if(mAliPlayer != null){
            speed = mAliPlayer.getSpeed();
        }
        return speed;
    }

    private void setVideoBackgroundColor(int color){
        if(mAliPlayer != null){
            mAliPlayer.setVideoBackgroundColor(color);
        }
    }

    private void setVolume(double volume){
        if(mAliPlayer != null){
            mAliPlayer.setVolume((float)volume);
        }
    }

    private double getVolume(){
        double volume = 1.0;
        if(mAliPlayer != null){
            volume = mAliPlayer.getVolume();
        }
        return volume;
    }

    private void setConfig(PlayerConfig playerConfig){
        if(mAliPlayer != null){
            mAliPlayer.setConfig(playerConfig);
        }
    }

    private PlayerConfig getConfig(){
        if(mAliPlayer != null){
            return mAliPlayer.getConfig();
        }
        return null;
    }
}
