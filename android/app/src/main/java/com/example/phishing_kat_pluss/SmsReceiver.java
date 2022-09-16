package com.example.phishing_kat_pluss;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;
import android.os.Build;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

public class SmsReceiver extends BroadcastReceiver {
    private static final String TAG = "SMSReceiver";
    public static String millidate;
    public static boolean smsRe=false; // wm은 한번만 띄울 수 있기 때문에 여러번 오는 문자에 대해서 내용만 바꿔주기 위함, true이면 내용만 바꾸고, false이면 띄움
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        SmsMessage[] messages = parseSmsMessage(bundle);


        if(messages.length > 0){
            String sender = messages[0].getOriginatingAddress();    //발신자
            String content = messages[0].getMessageBody().toString();   //내용

            Date date = new Date(messages[0].getTimestampMillis());
            millidate = String.valueOf(date.getTime()); //추가함
            SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
            String sendDate = sdf.format(date).toString();//날짜

            String score = Integer.toString(new Random().nextInt(100)+1);//점수
            String type = Integer.toString(new Random().nextInt(7));


            sendToService(context, sender, content, sendDate, score, type);
            Log.d(TAG, "sender: " + sender);
            Log.d(TAG, "content: " + content);
            Log.d(TAG, "score"+score);
            Log.d(TAG, "millidate"+millidate);
        }
    }

    private SmsMessage[] parseSmsMessage(Bundle bundle){
        // PDU: Protocol Data Units
        Object[] objs = (Object[]) bundle.get("pdus");
        SmsMessage[] messages = new SmsMessage[objs.length];

        for(int i=0; i<objs.length; i++){
            messages[i] = SmsMessage.createFromPdu((byte[])objs[i]);
        }

        return messages;
    }

    private void sendToService(Context context, String sender, String content, String date,String score, String type){
        Intent intent = new Intent(context, MyService.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                |Intent.FLAG_ACTIVITY_SINGLE_TOP
                |Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.putExtra("sender", sender);
        intent.putExtra("content", content);
        intent.putExtra("date", date);
        intent.putExtra("score", score);
        intent.putExtra("type", type);
        if( Build.VERSION.SDK_INT >= 26 )
        {
            context.startForegroundService(intent);
        }
        else {
            context.startService(intent);
        }
    }
}