package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.os.Build;
import android.text.TextUtils;
import android.view.Surface;
import android.view.TextureView;

import androidx.annotation.NonNull;

import com.aliyun.player.AliListPlayer;
import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.IPlayer;
import com.aliyun.player.VidPlayerConfigGen;
import com.aliyun.player.nativeclass.CacheConfig;
import com.aliyun.player.nativeclass.PlayerConfig;
import com.aliyun.player.source.StsInfo;
import com.aliyun.player.source.UrlSource;
import com.aliyun.player.source.VidAuth;
import com.aliyun.player.source.VidMps;
import com.aliyun.player.source.VidSts;
import com.cicada.player.utils.Logger;
import com.google.gson.Gson;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FluttreAliPlayerFactory extends PlatformViewFactory {

    private FlutterPlugin.FlutterPluginBinding mFlutterPluginBinding;

    private final Gson mGson;
    private IPlayer mIPlayer;
    private Context mContext;

    public FluttreAliPlayerFactory(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        super(StandardMessageCodec.INSTANCE);
        this.mContext = flutterPluginBinding.getApplicationContext();
        final AliPlayer mAliPlayer = AliPlayerFactory.createAliPlayer(flutterPluginBinding.getApplicationContext());
        final AliListPlayer mAliListPlayer = AliPlayerFactory.createAliListPlayer(flutterPluginBinding.getApplicationContext());
        final MethodChannel mAliPlayerMethodChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),"flutter_aliplayer");
        mAliPlayerMethodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                FluttreAliPlayerFactory.this.onMethodCall(call,result,mAliPlayer);
            }
        });

        MethodChannel mAliListPlayerMethodChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),"flutter_alilistplayer");
        mAliListPlayerMethodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                FluttreAliPlayerFactory.this.onMethodCall(call,result,mAliListPlayer);
            }
        });
        this.mFlutterPluginBinding = flutterPluginBinding;
        mGson = new Gson();
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        FlutterAliPlayerView flutterAliPlayerView = new FlutterAliPlayerView(context, viewId, args, mFlutterPluginBinding);
        initRenderView(flutterAliPlayerView);
        return flutterAliPlayerView;
    }

    private void initRenderView(FlutterAliPlayerView flutterAliPlayerView){
        TextureView mTextureView = (TextureView) flutterAliPlayerView.getView();
        if(mTextureView != null){
            mTextureView.setSurfaceTextureListener(new TextureView.SurfaceTextureListener() {
                @Override
                public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
                    Surface mSurface = new Surface(surface);
                    if(mIPlayer != null){
                        mIPlayer.setSurface(mSurface);
                    }
                }

                @Override
                public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
                    if(mIPlayer != null){
                        mIPlayer.surfaceChanged();
                    }
                }

                @Override
                public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
                    if(mIPlayer != null){
                        mIPlayer.setSurface(null);
                    }
                    return false;
                }

                @Override
                public void onSurfaceTextureUpdated(SurfaceTexture surface) {

                }
            });
        }
    }

    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result,IPlayer player) {
        mIPlayer = player;
        switch (methodCall.method) {
            case "setUrl":
                String url = methodCall.arguments.toString();
                setDataSource(url);
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
            case "destroy":
                release();
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
            case "isAutoPlay":
                result.success(isAutoPlay());
                break;
            case "setMuted":
                setMuted((Boolean)methodCall.arguments);
                break;
            case "isMuted":
                result.success(isMuted());
                break;
            case "setEnableHardwareDecoder":
                Boolean setEnableHardwareDecoderArgumnt = (Boolean) methodCall.arguments;
                setEnableHardWareDecoder(setEnableHardwareDecoderArgumnt);
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
            case "getCacheConfig":
                CacheConfig cacheConfig = getCacheConfig();
                String cacheConfigJson = mGson.toJson(cacheConfig);
                Map<String,Object> cacheConfigMap = mGson.fromJson(cacheConfigJson,Map.class);
                result.success(cacheConfigMap);
                break;
            case "setCacheConfig":
                Map<String,Object> setCacheConnfigMap = (Map<String, Object>) methodCall.arguments;
                String setCacheConfigJson = mGson.toJson(setCacheConnfigMap);
                CacheConfig setCacheConfig = mGson.fromJson(setCacheConfigJson,CacheConfig.class);
                setCacheConfig(setCacheConfig);
                break;
            case "getSDKVersion":
                result.success(getSDKVersion());
                break;
            case "addVidSource":
                String addSourceVid = methodCall.argument("vid");
                String vidUid = methodCall.argument("uid");
                addVidSource(addSourceVid,vidUid);
                break;
            case "addUrlSource":
                String addSourceUrl = methodCall.argument("url");
                String urlUid = methodCall.argument("uid");
                addUrlSource(addSourceUrl,urlUid);
                break;
            case "removeSource":
                String removeUid = methodCall.arguments();
                removeSource(removeUid);
                break;
            case "clear":
                clear();
                break;
            case "moveToNext":
                String moveToNextAccessKeyId = methodCall.argument("accId");
                String moveToNextAccessKeySecret = methodCall.argument("accKey");
                String moveToNextSecurityToken = methodCall.argument("token");
                String moveToNextRegion = methodCall.argument("region");
                StsInfo moveToNextStsInfo = new StsInfo();
                moveToNextStsInfo.setAccessKeyId(moveToNextAccessKeyId);
                moveToNextStsInfo.setAccessKeySecret(moveToNextAccessKeySecret);
                moveToNextStsInfo.setSecurityToken(moveToNextSecurityToken);
                moveToNextStsInfo.setRegion(moveToNextRegion);
                moveToNext(moveToNextStsInfo);
                break;
            case "moveToPre":
                String moveToPreAccessKeyId = methodCall.argument("accId");
                String moveToPreAccessKeySecret = methodCall.argument("accKey");
                String moveToPreSecurityToken = methodCall.argument("token");
                String moveToPreRegion = methodCall.argument("region");
                StsInfo moveToPreStsInfo = new StsInfo();
                moveToPreStsInfo.setAccessKeyId(moveToPreAccessKeyId);
                moveToPreStsInfo.setAccessKeySecret(moveToPreAccessKeySecret);
                moveToPreStsInfo.setSecurityToken(moveToPreSecurityToken);
                moveToPreStsInfo.setRegion(moveToPreRegion);
                moveToPre(moveToPreStsInfo);
                break;
            case "moveTo":
                String moveToAccessKeyId = methodCall.argument("accId");
                String moveToAccessKeySecret = methodCall.argument("accKey");
                String moveToSecurityToken = methodCall.argument("token");
                String moveToRegion = methodCall.argument("region");
                String moveToUid = methodCall.argument("uid");
                StsInfo moveToStsInfo = new StsInfo();
                moveToStsInfo.setAccessKeyId(moveToAccessKeyId);
                moveToStsInfo.setAccessKeySecret(moveToAccessKeySecret);
                moveToStsInfo.setSecurityToken(moveToSecurityToken);
                moveToStsInfo.setRegion(moveToRegion);
                moveTo(moveToUid,moveToStsInfo);
                break;
            case "enableConsoleLog":
                Boolean enableLog = (Boolean) methodCall.arguments;
                enableConsoleLog(enableLog);
                break;
            case "setLogLevel":
                Integer level = (Integer) methodCall.arguments;
                setLogLevel(level);
                break;
            case "getLogLevel":
                result.success(getLogLevel());
                break;
            case "createDeviceInfo":
                result.success(createDeviceInfo());
                break;
            case "addBlackDevice":
                Map<String,String> addBlackDeviceMap = methodCall.arguments();
                String blackType = addBlackDeviceMap.get("black_type");
                String blackDevice = addBlackDeviceMap.get("black_device");
                addBlackDevice(blackType,blackDevice);
                break;
            default:
                result.notImplemented();
        }
    }

    private String getSDKVersion(){
        return com.aliyun.player.AliPlayerFactory.getSdkVersion();
    }

    private void setDataSource(String url){
        if(mIPlayer != null){
            UrlSource urlSource = new UrlSource();
            urlSource.setUri(url);
            ((AliPlayer)mIPlayer).setDataSource(urlSource);
        }
    }

    private void setDataSource(VidSts vidSts){
        if(mIPlayer != null){
            ((AliPlayer)mIPlayer).setDataSource(vidSts);
        }
    }

    private void setDataSource(VidAuth vidAuth){
        if(mIPlayer != null){
            ((AliPlayer)mIPlayer).setDataSource(vidAuth);
        }
    }

    private void setDataSource(VidMps vidMps){
        if(mIPlayer != null){
            ((AliPlayer)mIPlayer).setDataSource(vidMps);
        }
    }

    private void prepare(){
        if(mIPlayer != null){
            mIPlayer.prepare();
        }
    }

    private void start(){
        if(mIPlayer != null){
            mIPlayer.start();
        }
    }

    private void pause(){
        if(mIPlayer != null){
            mIPlayer.pause();
        }
    }

    private void stop(){
        if(mIPlayer != null){
            mIPlayer.stop();
        }
    }

    private void release(){
        if(mIPlayer != null){
            mIPlayer.release();
        }
    }

    private void setLoop(Boolean isLoop){
        if(mIPlayer != null){
            mIPlayer.setLoop(isLoop);
        }
    }

    private Boolean isLoop(){
        return mIPlayer != null && mIPlayer.isLoop();
    }

    private void setAutoPlay(Boolean isAutoPlay){
        if(mIPlayer != null){
            mIPlayer.setAutoPlay(isAutoPlay);
        }
    }

    private Boolean isAutoPlay(){
        if (mIPlayer != null) {
            mIPlayer.isAutoPlay();
        }
        return false;
    }

    private void setMuted(Boolean muted){
        if(mIPlayer != null){
            mIPlayer.setMute(muted);
        }
    }

    private Boolean isMuted(){
        if (mIPlayer != null) {
            mIPlayer.isMute();
        }
        return false;
    }

    private void setEnableHardWareDecoder(Boolean mEnableHardwareDecoder){
        if(mIPlayer != null){
            mIPlayer.enableHardwareDecoder(mEnableHardwareDecoder);
        }
    }

    private void setScaleMode(int model){
        if(mIPlayer != null){
            IPlayer.ScaleMode mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT;
            if(model == IPlayer.ScaleMode.SCALE_ASPECT_FIT.getValue()){
                mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT;
            }else if(model == IPlayer.ScaleMode.SCALE_ASPECT_FILL.getValue()){
                mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FILL;
            }else if(model == IPlayer.ScaleMode.SCALE_TO_FILL.getValue()){
                mScaleMode = IPlayer.ScaleMode.SCALE_TO_FILL;
            }
            mIPlayer.setScaleMode(mScaleMode);
        }
    }

    private int getScaleMode(){
        int scaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT.getValue();
        if (mIPlayer != null) {
            scaleMode =  mIPlayer.getScaleMode().getValue();
        }
        return scaleMode;
    }

    private void setMirrorMode(int mirrorMode){
        if(mIPlayer != null){
            IPlayer.MirrorMode mMirrorMode;
            if(mirrorMode == IPlayer.MirrorMode.MIRROR_MODE_HORIZONTAL.getValue()){
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_HORIZONTAL;
            }else if(mirrorMode == IPlayer.MirrorMode.MIRROR_MODE_VERTICAL.getValue()){
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_VERTICAL;
            }else{
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_NONE;
            }
            mIPlayer.setMirrorMode(mMirrorMode);
        }
    }

    private int getMirrorMode(){
        int mirrorMode = IPlayer.MirrorMode.MIRROR_MODE_NONE.getValue();
        if (mIPlayer != null) {
            mirrorMode = mIPlayer.getMirrorMode().getValue();
        }
        return mirrorMode;
    }

    private void setRotateMode(int rotateMode){
        if(mIPlayer != null){
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
            mIPlayer.setRotateMode(mRotateMode);
        }
    }

    private int getRotateMode(){
        int rotateMode = IPlayer.RotateMode.ROTATE_0.getValue();
        if(mIPlayer != null){
            rotateMode =  mIPlayer.getRotateMode().getValue();
        }
        return rotateMode;
    }

    private void setSpeed(double speed){
        if(mIPlayer != null){
            mIPlayer.setSpeed((float) speed);
        }
    }

    private double getSpeed(){
        double speed = 0;
        if(mIPlayer != null){
            speed = mIPlayer.getSpeed();
        }
        return speed;
    }

    private void setVideoBackgroundColor(int color){
        if(mIPlayer != null){
            mIPlayer.setVideoBackgroundColor(color);
        }
    }

    private void setVolume(double volume){
        if(mIPlayer != null){
            mIPlayer.setVolume((float)volume);
        }
    }

    private double getVolume(){
        double volume = 1.0;
        if(mIPlayer != null){
            volume = mIPlayer.getVolume();
        }
        return volume;
    }

    private void setConfig(PlayerConfig playerConfig){
        if(mIPlayer != null){
            mIPlayer.setConfig(playerConfig);
        }
    }

    private PlayerConfig getConfig(){
        if(mIPlayer != null){
            return mIPlayer.getConfig();
        }
        return null;
    }

    private CacheConfig getCacheConfig(){
        return new CacheConfig();
    }

    private void setCacheConfig(CacheConfig cacheConfig){
        if(mIPlayer != null){
            mIPlayer.setCacheConfig(cacheConfig);
        }
    }

    private void enableConsoleLog(Boolean enableLog){
        Logger.getInstance(mContext).enableConsoleLog(enableLog);
    }

    private void setLogLevel(int level){
        Logger.LogLevel mLogLevel;
        if(level == Logger.LogLevel.AF_LOG_LEVEL_NONE.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_NONE;
        }else if(level == Logger.LogLevel.AF_LOG_LEVEL_FATAL.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_FATAL;
        }else if(level == Logger.LogLevel.AF_LOG_LEVEL_ERROR.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_ERROR;
        }else if(level == Logger.LogLevel.AF_LOG_LEVEL_WARNING.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_WARNING;
        }else if(level == Logger.LogLevel.AF_LOG_LEVEL_INFO.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_INFO;
        }else if(level == Logger.LogLevel.AF_LOG_LEVEL_DEBUG.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_DEBUG;
        }else if(level == Logger.LogLevel.AF_LOG_LEVEL_TRACE.getValue()){
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_TRACE;
        }else{
            mLogLevel = Logger.LogLevel.AF_LOG_LEVEL_NONE;
        }
        Logger.getInstance(mContext).setLogLevel(mLogLevel);
    }

    private Integer getLogLevel(){
        return Logger.getInstance(mContext).getLogLevel().getValue();
    }

    private String createDeviceInfo(){
        AliPlayerFactory.DeviceInfo deviceInfo = new AliPlayerFactory.DeviceInfo();
        deviceInfo.model = Build.MODEL;
        return deviceInfo.model;
    }

    private void addBlackDevice(String blackType,String modelInfo){
        AliPlayerFactory.DeviceInfo deviceInfo = new AliPlayerFactory.DeviceInfo();
        deviceInfo.model = modelInfo;
        AliPlayerFactory.BlackType aliPlayerBlackType;
        if(!TextUtils.isEmpty(blackType) && blackType.equals("HW_Decode_H264")){
            aliPlayerBlackType = AliPlayerFactory.BlackType.HW_Decode_H264;
        }else{
            aliPlayerBlackType = AliPlayerFactory.BlackType.HW_Decode_HEVC;
        }
        AliPlayerFactory.addBlackDevice(aliPlayerBlackType,deviceInfo);
    }


    /** ========================================================= */

    private void addVidSource(String vid,String uid){
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).addVid(vid,uid);
        }
    }
    private void addUrlSource(String url,String uid){
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).addUrl(url,uid);
        }
    }

    private void removeSource(String uid){
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).removeSource(uid);
        }
    }

    private void clear(){
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).clear();
        }
    }

    private void moveToNext(StsInfo stsInfo) {
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).moveToNext(stsInfo);
        }
    }

    private void moveToPre(StsInfo stsInfo){
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).moveToPrev(stsInfo);
        }
    }

    private void moveTo(String uid,StsInfo stsInfo){
        if(mIPlayer != null){
            ((AliListPlayer)mIPlayer).moveTo(uid,stsInfo);
        }
    }
}
