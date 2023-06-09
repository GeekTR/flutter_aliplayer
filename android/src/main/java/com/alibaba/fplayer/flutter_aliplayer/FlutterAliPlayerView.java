package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;

import com.aliyun.player.AliListPlayer;
import com.aliyun.player.IPlayer;

import java.lang.ref.WeakReference;

import io.flutter.plugin.platform.PlatformView;


public class FlutterAliPlayerView implements PlatformView {

    private static final int ALIYUNN_PLAYER_SETSURFACE = 0x0001;
    private Context mContext;
    private IPlayer mPlayer;
    private int mViewId;
    private MyHandler mHandler = new MyHandler(this);

    private final SurfaceView mSurfaceView;
    private SurfaceHolder mSurfaceHolder;

    public FlutterAliPlayerView(Context context, int viewId) {
        this.mViewId = viewId;
        this.mContext = context;
        mSurfaceView = new SurfaceView(mContext);

        initRenderView(mSurfaceView);
    }

    public void setPlayer(IPlayer player) {
        this.mPlayer = player;
        mHandler.sendEmptyMessage(ALIYUNN_PLAYER_SETSURFACE);
    }


    @Override
    public View getView() {
        return mSurfaceView;
    }

    @Override
    public void dispose() {
        if(mFlutterAliPlayerViewListener != null){
            mFlutterAliPlayerViewListener.onDispose(mViewId);
        }
        mHandler.removeCallbacksAndMessages(null);
        mSurfaceHolder = null;
    }

    private void initRenderView(SurfaceView surfaceView) {

        if (surfaceView != null) {
            surfaceView.getHolder().addCallback(new SurfaceHolder.Callback() {
                @Override
                public void surfaceCreated(@NonNull SurfaceHolder surfaceHolder) {
                    mSurfaceHolder = surfaceHolder;
                    mHandler.sendEmptyMessage(ALIYUNN_PLAYER_SETSURFACE);
                }

                @Override
                public void surfaceChanged(@NonNull SurfaceHolder surfaceHolder, int i, int i1, int i2) {
                    if (mPlayer != null) {
                        mPlayer.surfaceChanged();
                    }
                }

                @Override
                public void surfaceDestroyed(@NonNull SurfaceHolder surfaceHolder) {
                    if(mPlayer instanceof AliListPlayer){
                        /*
                            当使用 pageView 实现列表播放时，会出现画面卡主，声音正常的问题。
                            原因：滑动到下一个界面后，先设置 Surface 给 ListPlayer，然后上一个
                                Surface 销毁，setSurface(null);
                            部分手机如果不设置为 null，多次调用 setSurface 会导致崩溃。因此在 handler
                            的事件里，先设置为 null，再设置 Surface.
                         */
                    }else{
                        mPlayer.setSurface(null);
                    }
                }
            });
        }
    }

    public interface FlutterAliPlayerViewListener{
        void onDispose(int viewId);
    }

    private FlutterAliPlayerViewListener mFlutterAliPlayerViewListener;

    public void setFlutterAliPlayerViewListener(FlutterAliPlayerViewListener listener){
        this.mFlutterAliPlayerViewListener = listener;
    }

    private static class MyHandler extends Handler {

        private WeakReference<FlutterAliPlayerView> mWeakReference;

        public MyHandler(FlutterAliPlayerView futterAliPlayerView){
            mWeakReference = new WeakReference<>(futterAliPlayerView);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            FlutterAliPlayerView flutterAliPlayerView = mWeakReference.get();
            if(flutterAliPlayerView == null){
                return ;
            }
            switch (msg.what){
                case ALIYUNN_PLAYER_SETSURFACE:
                    if(flutterAliPlayerView.mPlayer != null && flutterAliPlayerView.mSurfaceHolder != null){
                        flutterAliPlayerView.mPlayer.setDisplay(null);
                        flutterAliPlayerView.mPlayer.setDisplay(flutterAliPlayerView.mSurfaceHolder);
                    }
                    break;
            }
        }
    }
}