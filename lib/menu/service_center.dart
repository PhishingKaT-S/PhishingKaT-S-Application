import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';


import '../theme.dart';

class ServiceCenter extends StatelessWidget {
  const ServiceCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(title: '고객센터'),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFc6c6c6)),
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.support_agent_outlined, color: Color(0xFF939393),),
                    Text(' 카카오톡 챗봇 운영', style: AppTheme.service_center,),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                const Text("궁금하신 사항을 문의로 남겨주시면\n하루 이내로 빠른 답변을 받을 수 있습니다.", style: AppTheme.service_center,),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                const Text("운영시간은 평일 10:00~18:00입니다.", style: AppTheme.service_center_blue,)
              ],
            ),
          ),
          
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: OutlinedButton(
              onPressed: ()async{

                Uri url = await TalkApi.instance.addChannelUrl('_vwdxfb');
                //await TalkApi.instance.channelChatUrl('_ZeUTxl');

                // 연결 페이지 URL을 브라우저에서 열기
                try {
                  await launchBrowserTab(url);
                } catch (error) {
                  print('카카오톡 채널 추가 실패 $error');
                }
                // try {
                //   await launchBrowserTab(url);
                // } catch (error) {
                //   print('카카오톡 채널 채팅 실패 $error');
                // }
                // SafeArea(
                //     child: WebView(
                //     initialUrl: 'https://open.kakao.com/o/s1wI6J0d',
                //     javascriptMode: JavascriptMode.unrestricted,
                //     gestureNavigationEnabled: true,
                //     userAgent: "random",
                // ));
              },
              child: const Text('카카오톡 1:1 문의하기', style: TextStyle(color: Color(0xFF381e1f)),),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFffdc00),
                side: const BorderSide(color:Color(0xFFffdc00))
              )
              // ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFffdc00)),
              //   foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF381e1f)),
              //   shadowColor: MaterialStateProperty.all<Color>(Color(0xFFffdc00)),
              // ),


            ),
          )
        ],
      ),
    );
  }
}
