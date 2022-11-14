package com.example.phishing_kat_pluss;

import static com.example.phishing_kat_pluss.SmsReceiver.selectBlack;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class MMSReceiver extends BroadcastReceiver {
    private static final String TAG = "MMS BROADCAST";
    private Context _context;   //현재 문맥
    private static int registered=-1;
    private List<PhoneBook> phoneBooks; // 연락처 정보 저장하는 변수
    private boolean flag=false; //전화번호부 여부 변수
    @Override
    public void onReceive(Context context, Intent intent) {
        _context = context;
        SmsReceiver.smsRe=false;
        Runnable runn = new Runnable()
        {
            @Override
            public void run()
            {
                parseMMS();
            }
        };

        Handler handler = new Handler();
        handler.postDelayed(runn, 6000); // 시간이 너무 짧으면 못 가져오는게 있더라

    }

    private void parseMMS()
    {
        ContentResolver contentResolver = _context.getContentResolver();
        final String[] projection = new String[] { "_id" };
        Uri uri = Uri.parse("content://mms");
        Cursor cursor = contentResolver.query(uri, projection, null, null, "_id desc limit 1");

        if (cursor.getCount() == 0)
        {
            cursor.close();
            return;
        }

        cursor.moveToFirst();
        @SuppressLint("Range") String id = cursor.getString(cursor.getColumnIndex("_id"));
        cursor.close();

        String sender = parseNumber(id); //보낸사람
        String msg = parseMessage(id); //메시지
        msg.replaceAll("\n", " ");

        Date date = new Date(System.currentTimeMillis()); //현재 시간
        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
        String sendDate = sdf.format(date);//날짜
        String score ="";//점수
        String type ="";//타입
        SMS recentsms = new SMS(msg); //머신러닝

        if(_haveNetworkConnection(this._context)) registered = selectBlack(sender); //인터넷에 연결되어 있으면

        /* 알고리즘 밑 type*/
        phoneBooks = new PhoneBook().getContacts(_context);
        //Log.d("MMSReceiver.java | parseMMS", "|" + number + "|\n" + msg);
        for(int i =0; i<phoneBooks.size(); i++){
            String a = phoneBooks.get(i).getTel().replaceAll("-", "");
//                System.out.println(a);
            if(a.equals(sender)) {
                //                  System.out.println("확인");
                flag = true; // true로 해야됨
            }
        }
        if(!flag) {//전화번호부에 없거나 등
            //System.out.println(Math.round(recentsms.score));
            //System.out.println(recentsms.category);
            if(registered==-1) { // 우리 연락처에 없는 문자
                score=String.valueOf(Math.round(recentsms.score));//점수
                type=String.valueOf(recentsms.category);
            }else if(registered==0){ //우리 연락처 화이트 리스트 문자
                score = "-1";
                type="0";
            }else{ //  블랙리스트 일 때
                score = "100";
                type="0";
            }

            sendToService(_context, sender, msg, sendDate, score, type);
        }
    }

    @SuppressLint("Range")
    private String parseNumber(String $id)
    {
        String result = null;

        Uri uri = Uri.parse(MessageFormat.format("content://mms/{0}/addr", $id));
        String[] projection = new String[] { "address" };
        String selection = "msg_id = ? and type = 137";// type=137은 발신자
        String[] selectionArgs = new String[] { $id };

        Cursor cursor = _context.getContentResolver().query(uri, projection, selection, selectionArgs, "_id asc limit 1");

        if (cursor.getCount() == 0)
        {
            cursor.close();
            return result;
        }

        cursor.moveToFirst();
        result = cursor.getString(cursor.getColumnIndex("address"));
        cursor.close();

        return result;
    }

    @SuppressLint("Range")
    private String parseMessage(String $id)
    {
        String result = null;

        // 조회에 조건을 넣게되면 가장 마지막 한두개의 mms를 가져오지 않는다.
        Cursor cursor = _context.getContentResolver().query(Uri.parse("content://mms/part"), new String[] { "mid", "_id", "ct", "_data", "text" }, null, null, null);

        Log.i("MMSReceiver.java | parseMessage", "|mms 메시지 갯수 : " + cursor.getCount() + "|");
        if (cursor.getCount() == 0)
        {
            cursor.close();
            return result;
        }

        cursor.moveToFirst();
        while (!cursor.isAfterLast())
        {
            @SuppressLint("Range") String mid = cursor.getString(cursor.getColumnIndex("mid"));
            if ($id.equals(mid))
            {
                @SuppressLint("Range") String partId = cursor.getString(cursor.getColumnIndex("_id"));
                @SuppressLint("Range") String type = cursor.getString(cursor.getColumnIndex("ct"));
                if ("text/plain".equals(type))
                {
                    @SuppressLint("Range") String data = cursor.getString(cursor.getColumnIndex("_data"));

                    if (TextUtils.isEmpty(data)) {
                        result = cursor.getString(cursor.getColumnIndex("text"));
                    }
                    else
                        result = parseMessageWithPartId(partId);
                }
            }
            cursor.moveToNext();
        }
        cursor.close();

        return result;
    }


    private String parseMessageWithPartId(String $id)
    {
        Uri partURI = Uri.parse("content://mms/part/" + $id);
        InputStream is = null;
        StringBuilder sb = new StringBuilder();
        try
        {
            is = _context.getContentResolver().openInputStream(partURI);
            if (is != null)
            {
                InputStreamReader isr = new InputStreamReader(is, "UTF-8");
                BufferedReader reader = new BufferedReader(isr);
                String temp = reader.readLine();
                while (!TextUtils.isEmpty(temp))
                {
                    sb.append(temp);
                    temp = reader.readLine();
                }
            }
        }
        catch (IOException e)
        {
            e.printStackTrace();
        } finally
        {
            if (is != null)
            {
                try
                {
                    is.close();
                }
                catch (IOException e)
                {
                }
            }
        }
        return sb.toString();
    }

    private boolean _haveNetworkConnection(Context context) {
        boolean haveConnectedWifi = false;
        boolean haveConnectedMobile = false;

        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo[] netInfo = cm.getAllNetworkInfo();
        for (NetworkInfo ni : netInfo) {
            if (ni.getTypeName().equalsIgnoreCase("WIFI"))
                if (ni.isConnected())
                    haveConnectedWifi = true;
            if (ni.getTypeName().equalsIgnoreCase("MOBILE"))
                if (ni.isConnected())
                    haveConnectedMobile = true;
        }
        return haveConnectedWifi || haveConnectedMobile;
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