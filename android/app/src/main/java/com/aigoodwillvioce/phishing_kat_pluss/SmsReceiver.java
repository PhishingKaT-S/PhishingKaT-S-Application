package com.aigoodwillvioce.phishing_kat_pluss;


import static com.aigoodwillvioce.phishing_kat_pluss.MainActivity.lite_category;
import static com.aigoodwillvioce.phishing_kat_pluss.MainActivity.lite_smish;

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
import java.util.Arrays;
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

            try {
                Thread.sleep(1000); //1초 대기

            } catch (InterruptedException e) {
                e.printStackTrace();
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
                URL url = new URL("http://54.227.203.18/selectBlackList.php");
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
    private String[] keyword0= {"추가"};
    private String[] keyword1= {"인증", "발신", "번호", "카톡"};
    private String[] keyword2= {"권리", "차등", "이용", "전용", "거부","사고", "설명", "신청", "제외"};
    private String[] keyword3= {"승인","오전"};
    private String[] keyword4= {"빙자", "중층", "집행", "비대", "보건", "부처", "신한은행", "확보", "자영", "복지", "영업", "폐업", "수시", "운영", "카카오", "담당자", "부담", "인자", "감소", "상환", "직장인", "인원", "한도", "무관", "사항", "임차", "모두", "생계비", "연체", "지속", "중소", "일화", "시어", "위반", "국민", "현재", "충족", "기획재정부", "변동", "시작", "추가경정예산", "확산", "생활고", "이하", "매출", "대책", "천만원", "부지", "자료", "수료", "인상", "해당", "마지막", "운용", "재난", "개선", "입원", "적용", "보이스피싱", "휴직", "회복", "출발", "발송", "조건", "환자", "요약", "요구", "보증금", "하반기"};
    private String[] keyword5= {"나야", "이번", "액정", "엄마", "여기", "휴대폰", "수리", "잠시", "사용", "먹통", "고장", "답장", "아빠", "화면", "바로"};
    private String[] keyword6= {"오류", "해외", "국외", "정보", "안마", "부적정", "지불", "미만", "하락", "상담", "플러스", "제습기", "국내외", "한국", "화물", "일치", "유이", "최고", "원본", "카메라", "주문", "시불", "월간", "휘센", "번가", "소비자원", "약정", "변경", "지연", "주유", "이상", "조회", "소비자", "처리", "직구", "시신", "보류", "다음", "이자율", "주신", "노출", "가죽", "수정", "케이", "주소지", "대하", "일정", "시문", "에너지", "가산", "결제", "심의", "금지", "취소", "변제", "수령", "법정", "요망", "정상처리", "발급", "도로명", "의자", "코모", "접수", "예정", "최소", "플러스카드", "은행", "국민은행", "에어컨", "소파", "상환", "소니", "오류", "스파", "디몬", "기간", "금리", "익월", "연체", "모든", "이자", "여신", "로마", "수반", "현대", "국내", "물품", "소비자보호법", "하단", "완료", "통관", "위니", "세탁기", "입력", "냉장고", "국제", "전월", "실적", "아마존", "회비", "의무", "카톡", "이내", "신용카드", "유효","버터", "침대", "캐논", "포함", "불이익", "제한", "즉시", "원정", "지정", "본인"};
    private String[] keyword7= {"심사", "전용", "생활", "동의", "부족", "설명", "창업", "법률", "제외", "금융", "권리", "차등", "주시", "여유", "인지세", "수료", "저축은행", "면책", "대출", "시기", "소상", "상이","사업자", "공인",  "무소득", "적용", "일부", "채무", "사고", "사기", "립니", "증빙"};
    private String[] keyword8= {"방법", "등록", "정보", "시작", "분양", "재의", "예약", "오후", "축하", "일반", "채널", "기간", "시간", "인근", "포함", "승인", "수령", "오전", "아래", "이자", "책임", "중도", "개발", "경력", "임대", "예정"};
    private String[] keyword9= {"검찰", "경찰", "공정", "사실", "상식", "선거법", "위반", "허위"};

    private float[] array= {0.0f,0.0f,0.0f,0.0f,0.0f,
            0.0f,0.0f,0.0f,0.0f,0.0f,
            0.0f,0.0f,0.0f,0.0f,0.0f};

    private float[] ABAEwords = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f};
    public float score = 0.0f;
    public int category=-1;
    private Pattern phoneNumberPattern = Pattern.compile("(\\d{2,4})?(-|\\s)?(\\d{3,4})(-|\\s)?(\\d{3,4})");
    private Pattern URLPattern = Pattern.compile("(http)?(s)?:?(\\/\\/)?([a-z0-9\\w]+\\.*)+[a-z0-9]{2,4}");
    private Pattern moneyPattern = Pattern.compile(",(\\d{3})원");

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
//        String regex = "(\\d{2,4})?(-|\\s)?(\\d{3,4})(-|\\s)?(\\d{3,4})";
//        Pattern pattern = Pattern.compile(regex); //
        if(phoneNumberPattern.matcher(text).find()==true) {
            return 1.0f;
        }
        else return 0.0f;
    }
    private float urls(String text){
//        Pattern pattern = Pattern.compile("(http)?(s)?:?(\\/\\/)?([a-z0-9\\w]+\\.*)+[a-z0-9]{2,4}");
        if(URLPattern.matcher(text).find()==true) {
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
        if(text.contains("+") || text.contains("%") || text.contains("/")) return 1.0f;
        else return 0.0f;
    }

    private float smishing_symbol(String text){
        if(text.contains("만원") || text.contains("천원")|| text.contains("백원") || text.contains("십원")) return 1.0f;
//        Pattern pattern = Pattern.compile(",(\\d{3})원");
        if(moneyPattern.matcher(text).matches()) return 1.0f;
        else return 0.0f;
    }

    private void smishing_keywords(String text){
        int next_array_idx = 5;
        int i=0;
        for(int j =0; j<keyword0.length; j++)
            if(text.contains(keyword0[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;

                break;
            }
        i++;
        for(int j =0; j<keyword1.length; j++)
            if(text.contains(keyword1[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;

                break;
            }
        i++;
        for(int j =0; j<keyword2.length; j++)
            if(text.contains(keyword2[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword3.length; j++)
            if(text.contains(keyword3[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword4.length; j++)
            if(text.contains(keyword4[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword5.length; j++)
            if(text.contains(keyword5[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword6.length; j++)
            if(text.contains(keyword6[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword7.length; j++)
            if(text.contains(keyword7[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword8.length; j++)
            if(text.contains(keyword8[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
        for(int j =0; j<keyword9.length; j++)
            if(text.contains(keyword9[j])){
                array[next_array_idx+i]=1.0f;
                ABAEwords[i]=1.0f;
                break;
            }
        i++;
    }
    public float smsSmishScore(){
        float[][] ret= new float[1][1];
        ret[0][0]=0;
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
        for(int k=0; k<6; k++) {
            System.out.println(cat[0][k]);
            if(cat[0][k] > max_value){
                max_value = cat[0][k];
                index_max=k;
                System.out.println(index_max);
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