package com.example.phishing_kat_pluss;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;

public class SmsReceiver extends BroadcastReceiver {
    private static final String TAG = "SMSReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        SmsMessage[] messages = parseSmsMessage(bundle);


        if(messages.length > 0){
            String sender = messages[0].getOriginatingAddress();
            String content = messages[0].getMessageBody().toString();
            sendToService(context, sender, content);
            Log.d(TAG, "sender: " + sender);
            Log.d(TAG, "content: " + content);
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

    private void sendToService(Context context, String sender, String content){
        Intent intent = new Intent(context, MyService.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                |Intent.FLAG_ACTIVITY_SINGLE_TOP
                |Intent.FLAG_ACTIVITY_CLEAR_TOP);
        //Log.d(TAG, sender+ "123ij1kl23mj1kl23m1k2l");
        intent.putExtra("sender", sender);
        intent.putExtra("content", content);
        context.startService(intent);
    }
}