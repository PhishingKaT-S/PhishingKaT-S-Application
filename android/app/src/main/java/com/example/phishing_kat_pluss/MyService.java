package com.example.phishing_kat_pluss;

import static android.Manifest.permission.READ_PHONE_NUMBERS;
import static android.Manifest.permission.READ_PHONE_STATE;
import static android.Manifest.permission.READ_SMS;

import static com.example.phishing_kat_pluss.SmsReceiver.smsRe;

import android.annotation.TargetApi;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
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
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.TextView;

import androidx.core.app.ActivityCompat;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class MyService extends Service {
    public static String sms_type;
    private static final String TAG = "myService";
    WindowManager wm;
    View mView;
    private static String sender;
    private static String content;
    private static String type;
    private static String date;
    private static String score;
    private static String recipient;
    private static int smishing;

    TextView tv_sender;
    TextView tv_content;
    TextView tv_date;
    TextView tv_type;
    RadioGroup radioGroup;
    WindowManager.LayoutParams params;

    LinearLayout vis_layout;
    LinearLayout scoreLayout;

    /*db 연결 정보*/
    public static final String DATABASES_NAME = "PhishingKaTApp";
    public static final String url ="jdbc:mariadb://phishingkat-s-app.c6olgkvb6eow.us-west-1.rds.amazonaws.com:3306/PhishingKaTApp";
    public static final String username = "phishingkat3";
    public static final String passwd = "phishing3^kL03%!";
    public static final String TABLE_NAME = "sms";
    public MyService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId){
        if (!smsRe) {
            score = intent.getStringExtra("score"); //점수 intent 가져옴
            sender = intent.getStringExtra("sender");
            content = intent.getStringExtra("content");
            type = intent.getStringExtra("type");
            date = intent.getStringExtra("date");
            recipient = "0" + getMyPhoneNumber().substring(3);
            LayoutInflater inflate = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            wm = (WindowManager) getSystemService(WINDOW_SERVICE);

            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                params = new WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT,
                        WindowManager.LayoutParams.MATCH_PARENT,
                        WindowManager.LayoutParams.TYPE_SYSTEM_ALERT,
                        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_BLUR_BEHIND,
                        PixelFormat.TRANSLUCENT);
            } else {
                params = new WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT,
                        WindowManager.LayoutParams.MATCH_PARENT,
                        WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                                | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH | WindowManager.LayoutParams.FLAG_BLUR_BEHIND,
                        PixelFormat.TRANSLUCENT);
            }
            Log.d("MyPhonenumber", recipient);
            params.gravity = Gravity.LEFT | Gravity.TOP;
            mView = inflate.inflate(R.layout.view_in_service, null);

            //변수로 레이아웃 설정
            tv_date = (TextView) mView.findViewById(R.id.textView_date);
            tv_sender = (TextView) mView.findViewById(R.id.textView_sender);
            tv_content = (TextView) mView.findViewById(R.id.textView_content);
            tv_type = (TextView) mView.findViewById(R.id.textView_type);
            radioGroup = (RadioGroup) mView.findViewById(R.id.radio_group);


            vis_layout = (LinearLayout) mView.findViewById(R.id.showLayout);


            //이벤트 설정
            final Button bt = (Button) mView.findViewById(R.id.btn_cancel); // cancel
            bt.setOnClickListener(v -> {
                wm.removeView(mView);
                smsRe = false;
            });
            final Button call = (Button) mView.findViewById(R.id.btn_call);
            call.setOnClickListener(v -> {
                vis_layout.setVisibility(View.VISIBLE);
            });
            final Button call2 = (Button) mView.findViewById(R.id.btn_call2); //신고하기 버튼
            call2.setOnClickListener(v -> {
                /*
                 * 여기에는 디비로 저장하게끔 하는 method가 필요 result로 날려야겠다.
                 * 점수가 green인데 신고하기 누르면 smish를 1로 바꿈
                 * 점수가 not green인데 신고하기 누르면 type을 바꿈
                 * */
                int selectedId = radioGroup.getCheckedRadioButtonId();
                switch (selectedId) {
                    case R.id.radio_stock:
                        sms_type = type = "0";
                        break;
                    case R.id.radio_vishing:
                        sms_type = type = "1";
                        break;
                    case R.id.radio_insurance:
                        sms_type = type = "2";
                        break;
                    case R.id.radio_gambling:
                        sms_type = type = "3";
                        break;
                    case R.id.radio_survey:
                        sms_type = type = "4";
                        break;
                    case R.id.radio_telemarketing:
                        sms_type = type = "5";
                        break;
                    case R.id.radio_others:
                        sms_type = type = "6";
                        break;
                } // type 변경

                wm.removeView(mView); //작업이 끝났으므로 끔
                smsRe = false;
            });
            final Button cancel2 = (Button) mView.findViewById(R.id.btn_cancel2);
            cancel2.setOnClickListener(
                    v -> {
                        vis_layout.setVisibility(View.INVISIBLE);
                    }
            );

            //layout
            scorewithcolor(); // layout 설정
            tv_sender.setText(sender);
            tv_content.setText(content);
            tv_date.setText(date);
            setTextfromtype();

            //Log.d("DDDD", score);
            addsms(date, content, sender, Integer.parseInt(sms_type), recipient, smishing);       //public static void addsms(String _date, String _content, String _sender, int _smstype, String _recipient, int _smishing){
            wm.addView(mView, params);
            smsRe = true;
            return super.onStartCommand(intent, flags, startId);
        } else {
            recipient = "0" + getMyPhoneNumber().substring(3);
            score = intent.getStringExtra("score"); //점수 intent 가져옴
            sender = intent.getStringExtra("sender");
            content = intent.getStringExtra("content");
            type = intent.getStringExtra("type");
            date = intent.getStringExtra("date");


            tv_date = (TextView) mView.findViewById(R.id.textView_date);
            tv_sender = (TextView) mView.findViewById(R.id.textView_sender);
            tv_content = (TextView) mView.findViewById(R.id.textView_content);
            tv_type = (TextView) mView.findViewById(R.id.textView_type);
            radioGroup = (RadioGroup) mView.findViewById(R.id.radio_group);

            scorewithcolor(); // layout 설정
            tv_sender.setText(sender);
            tv_content.setText(content);
            tv_date.setText(date);
            setTextfromtype();

            addsms(date, content, sender, Integer.parseInt(sms_type), recipient, smishing);       //public static void addsms(String _date, String _content, String _sender, int _smstype, String _recipient, int _smishing){

            return super.onStartCommand(intent, flags, startId);
        }
    }

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

    //type 설정
    void setTextfromtype() {
        if (Integer.parseInt(score) < 40) {
            tv_type.setText(R.string.safe);
            radioGroup.check(R.id.radio_others);
            smishing = 0;
        } else {
            smishing= 1;
            switch (Integer.parseInt(type)) {
                case 0:
                    tv_type.setText(R.string.stock);
                    radioGroup.check(R.id.radio_stock);
                    sms_type = "0";
                    break;
                case 1:
                    tv_type.setText(R.string.vishing);
                    radioGroup.check(R.id.radio_vishing);
                    sms_type = "1";
                    break;
                case 2:
                    tv_type.setText(R.string.insurance);
                    radioGroup.check(R.id.radio_insurance);
                    sms_type = "2";
                    break;
                case 3:
                    tv_type.setText(R.string.gambling);
                    radioGroup.check(R.id.radio_gambling);
                    sms_type = "3";
                    break;
                case 4:
                    tv_type.setText(R.string.survey);
                    radioGroup.check(R.id.radio_survey);
                    sms_type = "4";
                    break;
                case 5:
                    tv_type.setText(R.string.telemarketing);
                    radioGroup.check(R.id.radio_telemarketing);
                    sms_type = "5";
                    break;
                case 6:
                    tv_type.setText(R.string.others);
                    radioGroup.check(R.id.radio_others);
                    sms_type = "6";
                    break;
            }
        }
    }

    void scorewithcolor() {
        scoreLayout = (LinearLayout) mView.findViewById(R.id.scoreColor);
        //Log.d("scorewithcolor",score);
        if (Integer.parseInt(score) < 40) {
            scoreLayout.setBackgroundResource(R.drawable.upperbackgreen);
        } else if (Integer.parseInt(score) < 60) {
            scoreLayout.setBackgroundResource(R.drawable.upperbackgrey);
        } else if (Integer.parseInt(score) < 70) {
            scoreLayout.setBackgroundResource(R.drawable.upperbackyellow);
        } else if (Integer.parseInt(score) < 80) {
            scoreLayout.setBackgroundResource(R.drawable.upperbackorange);
        } else {
            scoreLayout.setBackgroundResource(R.drawable.upperbackred);
        }
    }

    //내 휴대폰 번호 가져와야됨
    public String getMyPhoneNumber() {
        if (ActivityCompat.checkSelfPermission(this, READ_SMS) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, READ_PHONE_NUMBERS) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return " error ";
        }else {
            return ((TelephonyManager) getSystemService(TELEPHONY_SERVICE))
                    .getLine1Number();
        }
    }

    public static void addsms(String _date, String _content, String _sender, int _smstype, String _recipient, int _smishing){
        new Thread(()->{
            try{
                /*Class.forName("org.mariadb.jdbc.Driver");
                Connection connection = DriverManager.getConnection(url, username, passwd);
                System.out.println("Database Connection success ");
                Statement statement = connection.createStatement();
                statement.execute("insert into sms values(30,18, '01029601776', '2022-08-30 00:00:00', 'abcd', '01029601776', 0, 0 )");
                //statement.execute("insert into "+ TABLE_NAME+"(user_id, user_ph, received_sms_date, text, sender_ph, type, smishing) select b.id, b.phone_number, '" +_date +"' , '"+ _content+"', '"+_sender + "', "+_smstype+", "+_smishing + " select id, phone_number from users where phone_number='"+_recipient+"') as b");
                connection.close();*/


            }catch(Exception e){
                Log.d("sms","sms error");
                e.printStackTrace();
            }
        }).start();
    }


}