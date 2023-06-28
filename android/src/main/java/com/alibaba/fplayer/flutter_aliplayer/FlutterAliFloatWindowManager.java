package com.alibaba.fplayer.flutter_aliplayer;

import android.content.Context;
import android.graphics.PixelFormat;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.WindowManager;

import androidx.annotation.NonNull;

public class FlutterAliFloatWindowManager {

   private final WindowManager mWindowManager;
   private final DisplayMetrics mDisplayMetrics;
   private final WindowManager.LayoutParams mLayoutParams;
   private final SurfaceView mSurfaceView;
   private Context mContext;
   private FlutterAliPlayerView mCurrentView;

   public FlutterAliFloatWindowManager(Context context){
      this.mContext = context;
      mWindowManager = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
      mDisplayMetrics = mContext.getResources().getDisplayMetrics();
      mLayoutParams = new WindowManager.LayoutParams(350, 450, 0, 0, PixelFormat.TRANSPARENT);
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
         mLayoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
      } else {
         mLayoutParams.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
      }
//      layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
//              | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
//              | WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED;
      mLayoutParams.format = PixelFormat.RGBA_8888; //窗口透明
//      layoutParams.gravity = Gravity.END | Gravity.BOTTOM;
      mLayoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
      mLayoutParams.x= mDisplayMetrics.widthPixels - 100;
      mLayoutParams.y= mDisplayMetrics.heightPixels - 100;

      mSurfaceView = new SurfaceView(context);
      mSurfaceView.getHolder().addCallback(new SurfaceHolder.Callback() {
         @Override
         public void surfaceCreated(@NonNull SurfaceHolder surfaceHolder) {
            if (mCurrentView != null) {
               mCurrentView.getPlayer().setDisplay(surfaceHolder);
            }
         }

         @Override
         public void surfaceChanged(@NonNull SurfaceHolder surfaceHolder, int i, int i1, int i2) {
            if (mCurrentView != null) {
               mCurrentView.getPlayer().surfaceChanged();
            }
         }

         @Override
         public void surfaceDestroyed(@NonNull SurfaceHolder surfaceHolder) {

         }
      });
   }


   public void showFloatWindow(FlutterAliPlayerView flutterAliPlayerView){
      this.mCurrentView = flutterAliPlayerView;
      mWindowManager.addView(mSurfaceView, mLayoutParams);
   }

   public void hideFloatWindow(){
      if (mSurfaceView != null) {
         mWindowManager.removeView(mSurfaceView);
      }
      if (mCurrentView != null) {
         mCurrentView.sendSetRenderViewMessage();
         mCurrentView = null;
      }
   }
}
