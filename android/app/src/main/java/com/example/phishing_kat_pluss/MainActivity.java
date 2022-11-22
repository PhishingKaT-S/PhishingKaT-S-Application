package com.example.phishing_kat_pluss;

import static android.service.controls.ControlsProviderService.TAG;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.ContentUris;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;

import org.tensorflow.lite.Interpreter;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    static final int PERMISSION_REQUEST_READ_SMS = 0x000001;
    String myPhoneNum = "01041609587";

    // Java API 에서는 CHANNEL 이름을 통해 실행
    // CHANNEL 변수의 값과 Flutter의 Channel 값이 동일해야합니다.
    private static final String CHANNEL = "samples.flutter.dev/channel";
    private static final int ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 1;
    private static final String CHANNEL2 = "phishingkat.flutter.android"; //지원
    private static final String CHANNEL3 = "onestore";
    private int num_of_sms_and_mms = 0 ;
    public static Interpreter lite_smish;
    public static Interpreter lite_category;
    ArrayList<String> sms = new ArrayList<String>();

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            int sms_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS);
                            int contact_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS);
                            int contact_state_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE);

                            if (sms_permission == PackageManager.PERMISSION_GRANTED &&
                                    contact_permission == PackageManager.PERMISSION_GRANTED &&
                                    contact_state_permission == PackageManager.PERMISSION_GRANTED) {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    sms.clear();
                                    num_of_sms_and_mms = 0 ;

                                    Uri sms_uri = Uri.parse("content://sms/");

                                    // SMS
                                    Cursor cursor_sms = this.getContentResolver().query(sms_uri, null, null, null, "date DESC");

                                    num_of_sms_and_mms += cursor_sms.getCount() ;

                                    // MMS
                                    Cursor cursor_mms = this.getContentResolver().query(Uri.parse("content://mms"),
                                            new String[]{"_id", "thread_id", "date", "read"}, null, null, "date DESC");

                                    num_of_sms_and_mms += cursor_mms.getCount() ;

                                    result.success("[NUM_OF_MSG]" + Integer.toString(num_of_sms_and_mms)) ;

                                    cursor_sms = this.readSMS(sms, cursor_sms);
                                    cursor_sms.close() ;


                                    cursor_mms = this.readMMS(sms, cursor_mms) ;
                                    cursor_mms.close() ;
                                }
                            }

                            result.success(sms);
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL2)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("showActivity")) {
                                checkPermission();
                                result.success("");
                            } else {
                                result.error("UNAVAILABLE", "Cannot Start Activity.", null);

                            }
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL3)
                .setMethodCallHandler((call, result) -> {
            if (call.method.equals("browseOneStore")) {
                final String url = call.argument("url");
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(intent);
            }
        });

//        int sms_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) ;
//        int contact_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) ;
//        int contact_state_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) ;
//
//        if ( sms_permission == PackageManager.PERMISSION_DENIED ||
//                contact_permission == PackageManager.PERMISSION_DENIED ||
//                contact_state_permission == PackageManager.PERMISSION_DENIED) {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                requestPermissions(new String[] { Manifest.permission.READ_SMS, Manifest.permission.READ_CONTACTS, Manifest.permission.READ_PHONE_STATE }, PERMISSION_REQUEST_READ_SMS) ;
//            }
//        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        lite_smish = getTfliteInterpreter("smish_converted_model.tflite");
        lite_category = getTfliteInterpreter("cate_converted_model.tflite");
//        OnCheckPermission();
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    public void OnCheckPermission() {
        int sms_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS);
        int contact_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS);
        int contact_state_permission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE);

        if (sms_permission == PackageManager.PERMISSION_DENIED ||
                contact_permission == PackageManager.PERMISSION_DENIED ||
                contact_state_permission == PackageManager.PERMISSION_DENIED) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestPermissions(new String[]{Manifest.permission.READ_SMS, Manifest.permission.READ_CONTACTS, Manifest.permission.READ_PHONE_STATE}, PERMISSION_REQUEST_READ_SMS);
            }
            return;
        }
    }

    // 사용자가 권한 요청 대화상자에 응답하면 시스템은 앱의 onRequestPermissionsResult() 메소드를 호출하게되고 이곳에서 결과에 대한 다음 작업을 진행
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case PERMISSION_REQUEST_READ_SMS:
                boolean check_result = true;

                for (int result : grantResults) {
                    if (result != PackageManager.PERMISSION_GRANTED) {
                        check_result = false;
                        break;
                    }
                }

                if (check_result) {
                    Toast.makeText(this, "앱 실행을 위한 권한이 설정되었습니다.", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(this, "앱 실행을 위한 권한이 취소되었습니다.", Toast.LENGTH_LONG).show();
//                    finish();
                }

                break;
        }
    }

    ////////////////////////////////////       SMS       ////////////////////////////////////////////////
    @SuppressLint("Range")
    public String phoneToName_sms(String phoneNumber) {
        if (phoneNumber.equals(myPhoneNum)) return "나";

        Uri uri = Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI, Uri.encode(phoneNumber));
        Cursor cursor = this.getContentResolver().query(uri, new String[]{ContactsContract.PhoneLookup.DISPLAY_NAME}, null, null, null);

        if (cursor == null) {
            return null;
        }

        String name = "(" + phoneNumber + ")";

        if (((Cursor) cursor).moveToFirst()) {
            name = cursor.getString(cursor.getColumnIndex(ContactsContract.PhoneLookup.DISPLAY_NAME));
        }

        if (cursor != null && !cursor.isClosed()) {
            cursor.close();
        }

        return name;
    }

    public Cursor readSMS(ArrayList<String> _sms, Cursor cursor) {
//        Uri sms_uri = Uri.parse("content://sms/");
//        Cursor cursor = this.getContentResolver().query(sms_uri, null, null, null, "date DESC");
//        int count = cursor.getCount();

//        Log.i(TAG, "SMS Count = " + count);
//        ArrayList<MessageInfo> al_sms = new ArrayList<MessageInfo>();

        while (cursor.moveToNext()) {
//            for (int i = 0; i < cursor.getColumnCount(); i++) {
//                Log.i(cursor.getColumnName(i) + "", cursor.getString(i) + "");
//            }
            @SuppressLint("Range") String body = cursor.getString(cursor.getColumnIndex("body"));
            // 내용 없는 메시지 제외
            if (!body.trim().isEmpty()) {
                @SuppressLint("Range") String phone = cursor.getString(cursor.getColumnIndex("address"));
                String name = phoneToName_sms(phone);
                @SuppressLint("Range") long date = cursor.getLong(cursor.getColumnIndex("date"));
                if (date < 10000000000L) date = date * 1000;
//                al_sms.add(new MessageInfo(name, phone, date, body));
                _sms.add(name + "[sms_text]" + phone + "[sms_text]" + Long.toString(date) + "[sms_text]" + body);
            }
        }
//        cursor.close();
        return cursor;
    }

    ////////////////////////////////////       MMS       ////////////////////////////////////////////////
    // thread_id로 전화번호 가져오기
    public String getPhoneByTheadId(long thread_id) {
        String phone = "";
        Uri uri = ContentUris.withAppendedId(Uri.parse("content://mms-sms/canonical-address"), thread_id);
        Cursor cursor = this.getContentResolver().query(uri, null, null, null, null);

        try {
            if (cursor.moveToFirst()) {
                phone = cursor.getString(0);
            }
        } finally {
            cursor.close();
        }

        return phone;
    }

    // 전화번호로 이름 가져오기(MMS)
    @SuppressLint("Range")
    public String phoneToName_mms(String phoneNumber) {
        Uri uri = Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI, Uri.encode(phoneNumber));
        String[] projection = {ContactsContract.PhoneLookup.DISPLAY_NAME, ContactsContract.PhoneLookup.NORMALIZED_NUMBER};
        Cursor cursor = this.getContentResolver().query(uri, projection, null, null, null);

        String name = null;
        try {
            if (cursor.moveToFirst()) {
                phoneNumber = cursor.getString(cursor.getColumnIndex(ContactsContract.PhoneLookup.NORMALIZED_NUMBER));
                name = cursor.getString(cursor.getColumnIndex(ContactsContract.PhoneLookup.DISPLAY_NAME));
            }
        } finally {
            cursor.close();
        }
        // if there is a display name, then return that
        if (name != null) {
            return name;
        } else {
            if (phoneNumber.equals(myPhoneNum)) return "나";
            return "(" + phoneNumber + ")"; // if there is not a display name, then return just phone number
        }
    }

    // thead_Id로 이름 가져오기
    // (Umarov) http://stackoverflow.com/questions/39953872/android-how-to-find-contact-name-and-number-from-recipient-ids
    public String getNameByTheadId(long thead_Id) {

        String name = "";
        Uri uri = ContentUris.withAppendedId(Uri.parse("content://mms-sms/canonical-address"), thead_Id);
        Cursor cursor = this.getContentResolver().query(uri, null, null, null, null);

        try {
            if (cursor.moveToFirst()) {
                name = phoneToName_mms(cursor.getString(0));
            }
        } finally {
            cursor.close();
        }

        return name;
    }

    // android MMS 모니터링 http://devroid.com/80181708954
    private String getMmsText(String id) {
        Uri partURI = Uri.parse("content://mms/part/" + id);
        InputStream is = null;
        StringBuilder sb = new StringBuilder();
        try {
            is = this.getContentResolver().openInputStream(partURI);
            if (is != null) {
                InputStreamReader isr = new InputStreamReader(is, "UTF-8");
                BufferedReader reader = new BufferedReader(isr);
                String temp = reader.readLine();
                while (temp != null) {
                    sb.append(temp);
                    // if (sb.length() > 100) break;
                    temp = reader.readLine();
                }
            }
        } catch (IOException e) {
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                }
            }
        }
        return sb.toString().trim();
    }

    // MMS 메시지(텍스트/이모티콘) 가져오기
    @SuppressLint("Range")
    public String messageFromMms(String mmsId) {
        String selectionPart = "mid=" + mmsId;
        Uri uriPart = Uri.parse("content://mms/part");
        Cursor cursor = this.getContentResolver().query(uriPart, null, selectionPart, null, null);

        String messageBody = "";
        if (cursor.moveToFirst()) {
            do {
                @SuppressLint("Range") String partId = cursor.getString(cursor.getColumnIndex("_id"));
                @SuppressLint("Range") String type = cursor.getString(cursor.getColumnIndex("ct"));

                if ("text/plain".equals(type)) {
                    @SuppressLint("Range") String data = cursor.getString(cursor.getColumnIndex("_data"));

                    if (!messageBody.isEmpty()) messageBody += "\n";
                    if (data != null) {
                        messageBody += getMmsText(partId);
                    } else {
                        messageBody += cursor.getString(cursor.getColumnIndex("text"));
                    }
                }
            } while (cursor.moveToNext());
            cursor.close();
        }
        if (cursor != null && !cursor.isClosed()) {
            cursor.close();
        }

        return messageBody;
    }

    public Cursor readMMS(ArrayList<String> _mms, Cursor cursor) {
//        Cursor cursor = this.getContentResolver().query(Uri.parse("content://mms"),
//                new String[]{"_id", "thread_id", "date", "read"},
//                null, null,
//                "date DESC");

        while (cursor.moveToNext()) {
            @SuppressLint("Range") String body = messageFromMms(cursor.getString(cursor.getColumnIndex("_id")));
            // 내용 없는 메시지 제외
            if (!body.trim().isEmpty()) {
                // thread_id > 상대방 이름(전화번호)
                long thread_id = cursor.getLong(cursor.getColumnIndexOrThrow("thread_id"));
                String phone = getPhoneByTheadId(thread_id);
                // String name = phoneToName_mms(phone); // IllegalArgumentException - 커서 생성 줄에서
                String name = getNameByTheadId(thread_id);
                // String name = phoneToName_sms(phone); // IllegalArgumentException - 커서 생성 줄에서

                @SuppressLint("Range") long date = cursor.getLong(cursor.getColumnIndex("date"));
                if (date < 10000000000L) date = date * 1000;
                _mms.add(name + "[sms_text]" + phone + "[sms_text]" + Long.toString(date) + "[sms_text]" + body);
            }
        }
//        cursor.close();
        return cursor;
    }


    /*지원 추가 */
    public void checkPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {   // 마시멜로우 이상일 경우
            if (!Settings.canDrawOverlays(this)) {              // 체크
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName()));
                startActivityForResult(intent, ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE);
            } else {
                //startService(new Intent(MainActivity.this, MyService.class));
            }
        } else {
            //startService(new Intent(MainActivity.this, MyService.class));
        }
    }


    @TargetApi(Build.VERSION_CODES.M)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE) {
            if (!Settings.canDrawOverlays(this)) {
                // TODO 동의를 얻지 못했을 경우의 처리

            } else {
                //    startService(new Intent(MainActivity.this, MyService.class));
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        lite_smish.close();
        lite_category.close();
    }


    /*tf lite 파일 권한 때문*/
    public Interpreter getTfliteInterpreter(String modelPath) {
        try {
            return new Interpreter(loadModelFile(MainActivity.this, modelPath));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public MappedByteBuffer loadModelFile(MainActivity activity, String modelPath) throws IOException {
        AssetFileDescriptor fileDescriptor = activity.getAssets().openFd(modelPath);
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
    }

    //////////////////////////////////////////////////////////////////////////////////
//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngin flutterEngine){
//        super.configureFlutterEngine(flutterEngine);
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL3).setMethodCallHandler((call, result) -> {
//            if(call.method.equals("browseOneStore")){
//                Intent intent  = new Intent(Intent.ACTION_VIEW, Uri.parse("https://m.onestore.co.kr/mobilepoc/apps/appsDetail.omp?prodId=0000758242"));
//                startActivity(intent);
//            }
//        });
//    }

}
