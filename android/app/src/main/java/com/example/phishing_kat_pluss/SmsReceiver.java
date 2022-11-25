package com.example.phishing_kat_pluss;


import static com.example.phishing_kat_pluss.MainActivity.lite_category;
import static com.example.phishing_kat_pluss.MainActivity.lite_smish;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.telephony.SmsMessage;
import android.util.Log;
import android.os.Build;

import org.json.JSONArray;
import org.json.JSONObject;
import org.tensorflow.lite.Interpreter;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.MappedByteBuffer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SmsReceiver extends BroadcastReceiver {
    private static final String TAG = "SMSReceiver";
    public static String millidate;
    public static boolean smsRe=false; // wm은 한번만 띄울 수 있기 때문에 여러번 오는 문자에 대해서 내용만 바꿔주기 위함, true이면 내용만 바꾸고, false이면 띄움
    private List<PhoneBook> phoneBooks; // 연락처 정보 저장하는 변수
    private boolean flag = false; //전화전호가 있는지 확인 하는 변수
    private static int registered=-1;
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
            String score ="";//점수
            String type ="";
            SMS recentsms = new SMS(content);
            if(haveNetworkConnection(context)) registered = selectBlack(sender); //인터넷에 연결되어 있으면

            /* 알고리즘 밑 type*/
            phoneBooks = new PhoneBook().getContacts(context);

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


                sendToService(context, sender, content, sendDate, score, type);
            }
            Log.d(TAG, "sender: " + sender);
            Log.d(TAG, "content: " + content);
            Log.d(TAG, "score"+score);
            Log.d(TAG, "millidate"+millidate);
        }


    }

    private boolean haveNetworkConnection(Context context) {
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
    //블랙리스트면 1, 화이트리스트면 0, 없으면 -1 리턴;
    public static int selectBlack(String phonenumber) {
        new Thread(() -> {
            try {
                StringBuffer sb = new StringBuffer();
                URL url = new URL("http://54.153.117.158/selectBlackList.php");
                HttpURLConnection con = (HttpURLConnection) url.openConnection();
                con.setDoOutput(true);
                con.setDoInput(true);
                con.setRequestMethod("POST");

                Map<String, String> parameters = new HashMap<>();
                parameters.put("phonenumber", phonenumber);



                DataOutputStream out = new DataOutputStream(con.getOutputStream());
                out.writeBytes(ParameterStringBuilder.getParamsString(parameters));
                out.flush();
                out.close();
                int responseCode = con.getResponseCode();
                System.out.println(responseCode);
                System.out.println("\nSending 'POST' request to URL at update : " + url);
                Log.d("resposecode", String.valueOf(responseCode));
                if(responseCode==HttpURLConnection.HTTP_OK) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
                    while (true) {
                        String line = br.readLine();
                        if (line == null) break;
                        sb.append(line + "\n");
                    }
                    br.close();
                }
                JSONObject jsonObj = new JSONObject(sb.toString());
                JSONArray jArray = (JSONArray) jsonObj.get("webnautes");
                JSONObject row = jArray.getJSONObject(0);
                MemberDTO dto = new MemberDTO();

                Log.d("받아온 값 _isblack", row.getString("phone"));
                registered=row.getInt("blacklist");
                //Log.d("받아온 값 _isblack", String.valueOf(row.getInt("blacklist")));
                dto.setPhone(row.getString("phone"));
                dto.setBlack(row.getInt("blacklist"));
                //items.add(dto);
                row.getInt("blacklist");
                Log.d("받아온 값 _isblack", String.valueOf(row.getInt("blacklist")));


            } catch (Exception e) {
                Log.d("sms update", "black list error");
                e.printStackTrace();
            }
        }).start();
        return registered;
    }




}


class SMS{ //전화 형식을 잘 맞춰야 할 듯 여러개로 fix시키는게 좋을듯
    private String text;
    private String [][] abaeKeyword = { //20*9 행렬
            {"아이디", "확인", "방식", "문의", "수리", "연락", "건강검진", "국제", "서류"},
            {"수리", "아이디", "비율", "확인", "규제", "아빠", "전화", "은행", "중도"},
            {"국제", "배송", "확인", "요청", "아이디", "서류", "경감", "자산", "대한"},
            {"일화", "번호", "오류", "규제", "모든", "대상", "안내", "조심", "국민"},
            {"법령", "신고", "발급", "배송", "이상", "전산", "개인", "문의", "자산"},
            {"제외", "노출", "아빠", "방문", "우대금리", "확인", "지정", "요청", "여기"},
            {"수리", "발급", "방식", "최고", "국제", "확인", "심의", "자동", "신고"},
            {"교통", "은행", "문의", "배송", "공인", "수리", "국제", "일치", "제공"},
            {"국제", "원본", "일시", "원금", "문의", "노출", "참고", "코로나", "분할"},
            {"긴급", "기타", "대출", "일부", "매출", "전화", "기준", "문의", "조회"},
            {"당일", "확인", "기한", "천만", "아빠", "문의", "수리", "역시", "배송"},
            {"긴급", "대한", "개인", "최저", "바로", "조회", "변경", "생활", "시간"},
            {"수리", "정상처리", "확인", "노출", "우대금리", "요청", "카톡", "원금", "당일"},
            {"확인", "지금", "일치", "문의", "대출", "은행", "안내", "생활", "수리"},
            {"수시", "년도", "원금", "운영", "처리", "경감", "아빠", "안내", "일용직"},
            {"문의", "대출", "매출", "국제", "역시", "중도", "안정", "이자", "원금"},
            {"수리", "여기", "공단", "은행", "차등", "최초", "진시", "대한", "면책"},
            {"노출", "일부", "마감", "자산", "확인", "국제", "처리", "문의", "연결"},
            {"자산", "추가", "이자", "발급", "범위", "바로", "수리", "대한", "제외"},
            {"확인", "이자", "수리", "문의", "연결", "당일", "국제", "최저", "발급"}
    };
    private float[] array= new float[25];

    private float[] ABAEwords = new float[20];
    public float score = 0.0f;
    public int category=-1;

    SMS(String smstext){
        text = smstext;
        getFeat(text);
    }


    void getFeat(String text){
        array[0] = phone(text);
        array[1] = urls(text);
        array[2] = message_len(text);
        array[3] = mathematical_symbol(text);
        array[4] = smishing_symbol(text);
        smishing_keywords(text);
        score = smsSmishScore();
        category= smsSmishCategory();
    }

    private float phone(String text){
        String regex = "(\\d{2,4})?(-|\\s)?(\\d{3,4})(-|\\s)?(\\d{3,4})$";
        Pattern pattern = Pattern.compile(regex); //
        if(pattern.matcher(text).find()==true) {
            System.out.println("phone check");
            return 1.0f;
        }
        else return 0.0f;
    }
    private float urls(String text){
        Pattern pattern = Pattern.compile("(http)?(s)?:?(\\/\\/)?([a-z0-9\\w]+\\.*)+[a-z0-9]{2,4}");
        if(pattern.matcher(text).find()==true) {
            System.out.println("url check");
            return 1.0f;
        }
        else {
            return 0.0f;
        }
    }
    private float message_len(String text){
        if(text.length() >= 200) return 1.0f;
        else return 0.0f;
    }

    private float mathematical_symbol(String text){
        if(text.contains("+") || text.contains("-")|| text.contains("%") || text.contains("/")) return 1.0f;
        else return 0.0f;
    }

    private float smishing_symbol(String text){
        if(text.contains("만원") || text.contains("천원")|| text.contains("백원") || text.contains("십원")) return 1.0f;
        Pattern pattern = Pattern.compile(",(\\d{3})원");
        if(pattern.matcher(text).matches()) return 1.0f;
        else return 0.0f;
    }

    private void smishing_keywords(String text){
        for(int i =5; i<5+20; i++){ //keywords 행개수
            array[i]=0.0f;
            ABAEwords[i-5]=0.0f;
            for(int j=0; j<9; j++){ //keywords 열개수
                if(text.contains(abaeKeyword[i-5][j])){
                    array[i]=1.0f;
                    ABAEwords[i-5]=1.0f;
                    break;
                }
            }
        }
    }
    public float smsSmishScore(){
        float[][] ret= new float[1][1];
        lite_smish.run(array, ret);
        Log.d("받아온 값 Score", ""+ret[0][0]);
        return ret[0][0]*100f;
    }
    public int smsSmishCategory(){
        float[][] cat =new float[1][6];
        int index_max =0;
        lite_category.run(ABAEwords,cat);
        float max_value = cat[0][0];
        System.out.println(cat[0][0]);
        for(int i=1; i<6; i++) {
            System.out.println(cat[0][i]);
            if(cat[0][i] > max_value){
                index_max=i;
            }
        }
        Log.d("받아온 값 category", ""+index_max);
        return index_max;
        //
        //return (int)cat[0][0];
    }
}

class PhoneBook {

    private String id;
    private String name;
    private String tel;
    // private String address;
    // private String email;

    public List<PhoneBook> getContacts(Context context){
        // 데이터베이스 혹은 content resolver 를 통해 가져온 데이터를 적재할 저장소를 먼저 정의
        List<PhoneBook> datas = new ArrayList<>();

        // 1. Resolver 가져오기(데이터베이스 열어주기)
        // 전화번호부에 이미 만들어져 있는 ContentProvider 를 통해 데이터를 가져올 수 있음
        // 다른 앱에 데이터를 제공할 수 있도록 하고 싶으면 ContentProvider 를 설정
        // 핸드폰 기본 앱 들 중 데이터가 존재하는 앱들은 Content Provider 를 갖는다
        // ContentResolver 는 ContentProvider 를 가져오는 통신 수단
        ContentResolver resolver = context.getContentResolver();

        // 2. 전화번호가 저장되어 있는 테이블 주소값(Uri)을 가져오기
        Uri phoneUri = ContactsContract.CommonDataKinds.Phone.CONTENT_URI;

        // 3. 테이블에 정의된 칼럼 가져오기
        // ContactsContract.CommonDataKinds.Phone 이 경로에 상수로 칼럼이 정의
        String[] projection = { ContactsContract.CommonDataKinds.Phone.CONTACT_ID // 인덱스 값, 중복될 수 있음 -- 한 사람 번호가 여러개인 경우
                ,  ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
                ,  ContactsContract.CommonDataKinds.Phone.NUMBER};

        // 4. ContentResolver로 쿼리를 날림 -> resolver 가 provider 에게 쿼리하겠다고 요청
        Cursor cursor = resolver.query(phoneUri, projection, null, null, null);

        // 4. 커서로 리턴된다. 반복문을 돌면서 cursor 에 담긴 데이터를 하나씩 추출
        if(cursor != null){
            while(cursor.moveToNext()){
                // 4.1 이름으로 인덱스를 찾아준다
                int idIndex = cursor.getColumnIndex(projection[0]); // 이름을 넣어주면 그 칼럼을 가져와준다.
                int nameIndex = cursor.getColumnIndex(projection[1]);
                int numberIndex = cursor.getColumnIndex(projection[2]);
                // 4.2 해당 index 를 사용해서 실제 값을 가져온다.
                String id = cursor.getString(idIndex);
                String name = cursor.getString(nameIndex);
                String number = cursor.getString(numberIndex);

                PhoneBook phoneBook = new PhoneBook();
                phoneBook.setId(id);
                phoneBook.setName(name);
                phoneBook.setTel(number);

                datas.add(phoneBook);
            }
        }
        // 데이터 계열은 반드시 닫아줘야 한다.
        cursor.close();
        return datas;
    }

    public void setId(String id){
        this.id=id;
    }

    public void setName(String name){
        this.name=name;
    }

    public void setTel(String number){
        this.tel=number;
    }

    public String getId(){
        return id;
    }

    public String getTel(){
        return tel;
    }

}

class MemberDTO{
    private String phone;
    private int _isblack;

    public void setPhone(String phone){
        this.phone = phone;
    }

    public void setBlack(int black){
        this._isblack=black;
    }
    public String getPhone(){
        return phone;
    }
    public int getblack(){
        return _isblack;
    }
}