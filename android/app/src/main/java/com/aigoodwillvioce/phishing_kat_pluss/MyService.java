


package com.aigoodwillvioce.phishing_kat_pluss;

import static android.Manifest.permission.READ_PHONE_NUMBERS;
import static android.Manifest.permission.READ_PHONE_STATE;
import static android.Manifest.permission.READ_SMS;
import static com.aigoodwillvioce.phishing_kat_pluss.SmsReceiver.millidate;
import static com.aigoodwillvioce.phishing_kat_pluss.SmsReceiver.smsRe;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.IBinder;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;

import java.io.DataOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    private static int smishing=0;
    List<MemberDTO> items;


    TextView tv_sender;
    TextView tv_content;
    TextView tv_date;
    TextView tv_type;
    RadioGroup radioGroup;
    WindowManager.LayoutParams params;
    ImageView closeview;
    LinearLayout vis_layout;
    LinearLayout scoreLayout;


    /*스미싱에 등록되어 있는 번호*/


    public MyService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onCreate(){
        String CHANNEL_ID = "channel_1";
        NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Android test", NotificationManager.IMPORTANCE_LOW);

        ((NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE)).createNotificationChannel(channel);

        Notification notification =new NotificationCompat.Builder(this, CHANNEL_ID).setContentTitle("").setContentText("").build();
        startForeground(2, notification);
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


            //Log.d("SelectBlack List log ", sender);

            //이벤트 설정
            final Button bt = (Button) mView.findViewById(R.id.btn_cancel); // cancel 안전 버튼
            bt.setOnClickListener(v -> {
                RadioButton but_poilice = (RadioButton)mView.findViewById(R.id.radio_police);
                but_poilice.setText(R.string.safe_acqtype);
                RadioButton but_Mini = (RadioButton)mView.findViewById(R.id.radio_Minister);
                but_Mini.setText(R.string.safe_shippingtype);
                RadioButton but_bank= (RadioButton)mView.findViewById(R.id.radio_bank);
                but_bank.setText(R.string.safe_insttype);
                RadioButton but_corp = (RadioButton)mView.findViewById(R.id.radio_corp);
                but_corp.setText(R.string.safe_customtype);
                RadioButton but_shipping = (RadioButton)mView.findViewById(R.id.radio_shipping);
                but_shipping.setText(R.string.safe_shoppingtype);
                RadioButton but_acq = (RadioButton)mView.findViewById(R.id.radio_acquaint);
                but_acq.setText(R.string.safe_others);
                vis_layout.setVisibility(View.VISIBLE);
            });
            final Button call = (Button) mView.findViewById(R.id.btn_call);
            call.setOnClickListener(v -> {
                RadioButton but_poilice = (RadioButton)mView.findViewById(R.id.radio_police);
                but_poilice.setText(R.string.policetype);
                RadioButton but_Mini = (RadioButton)mView.findViewById(R.id.radio_Minister);
                but_Mini.setText(R.string.Ministertype);
                RadioButton but_bank= (RadioButton)mView.findViewById(R.id.radio_bank);
                but_bank.setText(R.string.banktype);
                RadioButton but_corp = (RadioButton)mView.findViewById(R.id.radio_corp);
                but_corp.setText(R.string.corptype);
                RadioButton but_shipping = (RadioButton)mView.findViewById(R.id.radio_shipping);
                but_shipping.setText(R.string.shippingtype);
                RadioButton but_acq = (RadioButton)mView.findViewById(R.id.radio_acquaint);
                but_acq.setText(R.string.acqtype);
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
                    case R.id.radio_police:
                        sms_type = type = "0";
                        break;
                    case R.id.radio_Minister:
                        sms_type = type = "1";
                        break;
                    case R.id.radio_bank:
                        sms_type = type = "4";
                        break;
                    case R.id.radio_corp:
                        sms_type = type = "5";
                        break;
                    case R.id.radio_shipping:
                        sms_type = type = "3";
                        break;
                    case R.id.radio_acquaint:
                        sms_type = type = "2";
                        break;
                } // type 변경

                updatesms(millidate, content, sender, Integer.parseInt(sms_type), recipient);

                wm.removeView(mView); //작업이 끝났으므로 끔
                smsRe = false;
            });
            final Button cancel2 = (Button) mView.findViewById(R.id.btn_cancel2);
            cancel2.setOnClickListener(
                    v -> {
                        vis_layout.setVisibility(View.INVISIBLE);
                    }
            );

            //close View
            closeview=(ImageView)mView.findViewById(R.id.close);
            closeview.setOnClickListener(v->{
                wm.removeView(mView);
                smsRe = false;
            });

            //layout
            scorewithcolor(); // layout 설정
            tv_sender.setText(sender);
            tv_content.setText(content);
            tv_date.setText(date);
            setTextfromtype();

            //Log.d("DDDD", score);
            try{
                //int num = Integer.parseInt(sms_type);
                addsms(date, content, sender, Integer.parseInt(type), recipient, smishing, score);       //public static void addsms(String _date, String _content, String _sender, int _smstype, String _recipient, int _smishing){
            } catch(NumberFormatException e){
                Log.d("MY SERVICE", "sms_type convert error");
            }catch(Exception e){
                Log.d("My service at ", "sms_type convert error");
            }

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

            try{
                int num = Integer.parseInt(type);
                addsms(date, content, sender, num, recipient, smishing, score);       //public static void addsms(String _date, String _content, String _sender, int _smstype, String _recipient, int _smishing){
            } catch(NumberFormatException e){
                Log.d("MY SERVICE part2", "sms_type convert error");
            }catch(Exception e){
                Log.d("My service at part2", "sms_type convert error");
            }

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
    @SuppressLint("StringFormatInvalid")
    void setTextfromtype() {
        int setTextScore;
        try {
            setTextScore = Integer.parseInt(score);
            if (setTextScore <0){
                tv_type.setText(R.string.safe);
                Button btn = (Button) mView.findViewById(R.id.btn_cancel);
                btn.setEnabled(false);
                radioGroup.check(R.id.radio_police);
                smishing = 0;
            }
            //      if (setTextScore < 40) {
            //          tv_type.setText(R.string.safe);
            //        radioGroup.check(R.id.radio_others);
            //        smishing = 0;
            else {
                if(setTextScore<40) smishing=0;
                else smishing= 1;
                Resources res = getResources();
                switch (Integer.parseInt(type)) {
                    case 0:
                        tv_type.setText(String.format(getString(R.string.police), score));
                        radioGroup.check(R.id.radio_police);
                        sms_type = "0";
                        break;
                    case 1:
                        tv_type.setText(String.format(getString(R.string.Minister), score));
                        radioGroup.check(R.id.radio_Minister);
                        sms_type = "1";
                        break;
                    case 4:
                        tv_type.setText(String.format(getString(R.string.bank), score));
                        radioGroup.check(R.id.radio_bank);
                        sms_type = "4";
                        break;
                    case 5:
                        tv_type.setText(String.format(getString(R.string.corp), score));
                        radioGroup.check(R.id.radio_corp);
                        sms_type = "5";
                        break;
                    case 3:
                        tv_type.setText(String.format(getString(R.string.shipping), score));
                        radioGroup.check(R.id.radio_shipping);
                        sms_type = "3";
                        break;
                    case 2:
                        tv_type.setText(String.format(getString(R.string.acquaint), score));
                        radioGroup.check(R.id.radio_acquaint);
                        sms_type = "2";
                        break;
                }
            }
        }catch(NumberFormatException e){
            System.out.print(e);
        }

    }


    void scorewithcolor() {
        scoreLayout = (LinearLayout) mView.findViewById(R.id.scoreColor);
        //Log.d("scorewithcolor",score);
        int number;
        try{
            number = Integer.parseInt(score);
            if(number < 0){
                scoreLayout.setBackgroundResource(R.drawable.upperbackgreen);
            }else if (number < 60) {
                scoreLayout.setBackgroundResource(R.drawable.upperbackgrey);
            } else if (number < 70) {
                scoreLayout.setBackgroundResource(R.drawable.upperbackyellow);
            } else if (number < 80) {
                scoreLayout.setBackgroundResource(R.drawable.upperbackorange);
            } else {
                scoreLayout.setBackgroundResource(R.drawable.upperbackred);
            }
        }catch(NumberFormatException e){
            Log.d("scorewithColor", "scorewithColor convert error");
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
    //db에 sms 추가
    public static void addsms(String _date, String _content, String _sender, int _smstype, String _recipient, int _smishing, String _score){
        new Thread(()->{
            try{
                URL url = new URL("http://54.227.203.18/db.php");
                HttpURLConnection con = (HttpURLConnection) url.openConnection();
                con.setDoOutput(true);
                con.setDoInput(true);
                con.setRequestMethod("POST");


                Map<String, String> parameters = new HashMap<>();
                parameters.put("date", millidate); //날짜가 특수문자 때문에 깨져서 만든 millisecond를 day로 바꿀 것
                parameters.put("content", _content);
                parameters.put("sender", _sender);
                parameters.put("type", String.valueOf(_smstype));
                //parameters.put("recipient", "01029601776");
                parameters.put("recipient", _recipient);
                parameters.put("smishing", String.valueOf(_smishing));
                parameters.put("score", _score);

                DataOutputStream out = new DataOutputStream(con.getOutputStream());
                out.writeBytes(ParameterStringBuilder.getParamsString(parameters));
                out.flush();
                out.close();
                int responseCode = con.getResponseCode();
                System.out.println("\nSending 'POST' request to URL at insert: " + url);
                Log.d("resposecode", String.valueOf(responseCode));

            }catch(Exception e){
                Log.d("sms","sms error");
                e.printStackTrace();
            }
        }).start();
    }
    public static void updatesms(String _date, String _content, String _sender, int _smstype, String _recipient){
        new Thread(()->{
            try {
                URL url = new URL("http://54.227.203.18/updatetype.php");
                HttpURLConnection con = (HttpURLConnection) url.openConnection();
                con.setDoOutput(true);
                con.setDoInput(true);
                con.setRequestMethod("POST");


                Map<String, String> parameters = new HashMap<>();
                parameters.put("date", millidate);
                parameters.put("content", _content);
                parameters.put("sender", _sender);
                parameters.put("type", String.valueOf(_smstype));
                //parameters.put("recipient", "01029601776");
                parameters.put("recipient", _recipient);

                DataOutputStream out = new DataOutputStream(con.getOutputStream());
                out.writeBytes(ParameterStringBuilder.getParamsString(parameters));
                out.flush();
                out.close();
                int responseCode = con.getResponseCode();
                System.out.println("\nSending 'POST' request to URL at update : " + url);
                Log.d("resposecode", String.valueOf(responseCode));
            }catch(Exception e){
                Log.d("sms update", "sms type update error");
                e.printStackTrace();
            }
        }
        ).start();
    }


    //db에 접근해서 블랙리스트에 있는지 확인

    /*private String converttoDate(String date){ //miili를 yyyy-MM-dd로 바꿈
        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
        String senddate = sdf.format(date).toString();//날짜
        return senddate;
    }*/
}


class ParameterStringBuilder {
    public static String getParamsString(Map<String, String> params)
            throws UnsupportedEncodingException{
        StringBuilder result = new StringBuilder();

        for (Map.Entry<String, String> entry : params.entrySet()) {
            result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            result.append("&");
        }
        String resultString = result.toString();
        Log.d("Myservice", resultString);
        return resultString.length() > 0
                ? resultString.substring(0, resultString.length() - 1)
                : resultString;
    }
}
