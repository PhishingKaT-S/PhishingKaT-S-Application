package com.example.phishing_kat_pluss;

import android.annotation.TargetApi;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

public class MyService extends Service {
    private static final String TAG = "myService";
    WindowManager wm;
    View mView;
    String sender;
    String content;
    TextView tv_sender;
    TextView tv_content;
    WindowManager.LayoutParams params;
    public MyService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId){
        sender = intent.getStringExtra("sender");
        content = intent.getStringExtra("content");

        LayoutInflater inflate = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        wm = (WindowManager) getSystemService(WINDOW_SERVICE);

        if(Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            params = new WindowManager.LayoutParams( WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_SYSTEM_ALERT,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                    PixelFormat.TRANSLUCENT);
        }
        else{
            params = new WindowManager.LayoutParams( WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                    PixelFormat.TRANSLUCENT);
        }

        params.gravity = Gravity.LEFT | Gravity.TOP;
        mView = inflate.inflate(R.layout.view_in_service, null);


        tv_sender = (TextView) mView.findViewById(R.id.textView_sender);
        tv_content= (TextView) mView.findViewById(R.id.textView_content);;
        final Button bt = (Button) mView.findViewById(R.id.btn_cancel);
        bt.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                wm.removeView(mView);
            }
        });

        tv_sender.setText(sender);
        tv_content.setText(content);



        wm.addView(mView, params);

        return super.onStartCommand(intent, flags, startId);
    }

/*
    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void onCreate(){
        super.onCreate();
        LayoutInflater inflate = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        wm = (WindowManager) getSystemService(WINDOW_SERVICE);

        if(Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            params = new WindowManager.LayoutParams( WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_SYSTEM_ALERT,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                    PixelFormat.TRANSLUCENT);
        }
        else{
            params = new WindowManager.LayoutParams( WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                    PixelFormat.TRANSLUCENT);
        }

        params.gravity = Gravity.LEFT | Gravity.TOP;
        mView = inflate.inflate(R.layout.view_in_service, null);


        tv_sender = (TextView) mView.findViewById(R.id.textView_sender);
        tv_content= (TextView) mView.findViewById(R.id.textView_content);;


        tv_sender.setText("sender");
        tv_content.setText(content);



        wm.addView(mView, params);


    }*/

    @Override
    public void onDestroy() {
        super.onDestroy();
        if(wm != null) {
            if(mView != null) {
                wm.removeView(mView);
                mView = null;
            }
            wm = null;
        }
    }


}