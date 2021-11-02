package com.alibaba.fplayer.flutter_aliplayer;

import com.aliyun.player.AliLiveShiftPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.IPlayer;
import com.aliyun.player.source.LiveShift;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterAliLiveShiftPlayer extends FlutterPlayerBase{

    private AliLiveShiftPlayer mAliLiveShiftPlayer;

    public FlutterAliLiveShiftPlayer(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String playerId) {
        this.mPlayerId = playerId;
        this.mContext = flutterPluginBinding.getApplicationContext();
        mAliLiveShiftPlayer = AliPlayerFactory.createAliLiveShiftPlayer(mContext);
        initListener(mAliLiveShiftPlayer);
    }

    @Override
    public IPlayer getAliPlayer() {
        return mAliLiveShiftPlayer;
    }

    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "getCurrentLiveTime":
                result.success(getCurrentLiveTime());
                break;
            case "getCurrentTime":
                result.success(getCurrentTime());
                break;
            case "seekToLiveTime":
                long seekToLiveTime = methodCall.argument("arg");
                seekToLiveTime(seekToLiveTime);
                break;
            case "setDataSource":
                Map<String,Object> dataSourceMap = (Map<String,Object>)methodCall.argument("arg");
                LiveShift liveShift = new LiveShift();
                liveShift.setTimeLineUrl((String) dataSourceMap.get("timeLineUrl"));
                liveShift.setUrl((String) dataSourceMap.get("url"));
                liveShift.setCoverPath((String) dataSourceMap.get("coverPath"));
                liveShift.setFormat((String) dataSourceMap.get("format"));
                liveShift.setTitle((String) dataSourceMap.get("title"));
                setDataSource(liveShift);
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
        }
    }

    @Override
    public void initListener(IPlayer player) {
        super.initListener(player);
        mAliLiveShiftPlayer.setOnTimeShiftUpdaterListener(new AliLiveShiftPlayer.OnTimeShiftUpdaterListener() {
            @Override
            public void onUpdater(long currentTime, long shiftStartTime, long shiftEndTime) {
                Map<String,Object> map = new HashMap<>();
                map.put("method","onUpdater");
                map.put("currentTime",currentTime);
                map.put("shiftStartTime",shiftStartTime);
                map.put("shiftEndTime",shiftEndTime);
                map.put("playerId",mPlayerId);
                if(mFlutterAliPlayerListener != null){
                    mFlutterAliPlayerListener.onTimeShiftUpdater(map);
                }
            }
        });

        mAliLiveShiftPlayer.setOnSeekLiveCompletionListener(new AliLiveShiftPlayer.OnSeekLiveCompletionListener() {
            @Override
            public void onSeekLiveCompletion(long playTime) {
                Map<String,Object> map = new HashMap<>();
                map.put("method","onSeekLiveCompletion");
                map.put("playTime",playTime);
                map.put("playerId",mPlayerId);
                if(mFlutterAliPlayerListener != null){
                    mFlutterAliPlayerListener.onSeekLiveCompletion(map);
                }
            }
        });
    }

    private void prepare(){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.prepare();
        }
    }

    private void start(){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.start();
        }
    }

    private void pause(){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.pause();
        }
    }

    private void stop(){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.stop();
        }
    }

    private void release(){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.release();
        }
    }

    private long getCurrentLiveTime() {
        if(mAliLiveShiftPlayer != null){
            return mAliLiveShiftPlayer.getCurrentLiveTime();
        }
        return 0;
    }

    private long getCurrentTime(){
        if(mAliLiveShiftPlayer != null){
            return mAliLiveShiftPlayer.getCurrentTime();
        }
        return 0;
    }

    private void setDataSource(LiveShift liveShift){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.setDataSource(liveShift);
        }
    }

    private void seekToLiveTime(long liveTime){
        if(mAliLiveShiftPlayer != null){
            mAliLiveShiftPlayer.seekToLiveTime(liveTime);
        }
    }
}
