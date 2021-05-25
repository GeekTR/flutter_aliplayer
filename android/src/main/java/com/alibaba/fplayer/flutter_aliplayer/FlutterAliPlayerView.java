package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;

import com.aliyun.player.IPlayer;

import io.flutter.plugin.platform.PlatformView;


public class FlutterAliPlayerView implements PlatformView {


    private Context mContext;
    private IPlayer mPlayer;
    private int mViewId;

    private final TextureView mTextureView;

    public FlutterAliPlayerView(Context context, int viewId) {
        this.mViewId = viewId;
        this.mContext = context;
        mTextureView = new TextureView(mContext);
        initRenderView(mTextureView);
    }

    public void setPlayer(IPlayer player) {
        this.mPlayer = player;
    }


    @Override
    public View getView() {
        return mTextureView;
    }

    @Override
    public void dispose() {
        if(mFlutterAliPlayerViewListener != null){
            mFlutterAliPlayerViewListener.onDispose(mViewId);
        }
    }

    private void initRenderView(TextureView mTextureView) {
        if (mTextureView != null) {
            mTextureView.setSurfaceTextureListener(new TextureView.SurfaceTextureListener() {
                @Override
                public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
                    Surface mSurface = new Surface(surface);
                    if (mPlayer != null) {
                        mPlayer.setSurface(mSurface);
                    }
                }

                @Override
                public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
                    if (mPlayer != null) {
                        mPlayer.surfaceChanged();
                    }
                }

                @Override
                public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
                    if (mPlayer != null) {
                        mPlayer.setSurface(null);
                    }
                    return false;
                }

                @Override
                public void onSurfaceTextureUpdated(SurfaceTexture surface) {

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
}