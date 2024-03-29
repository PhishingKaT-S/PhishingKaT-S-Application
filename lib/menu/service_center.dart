import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';


import '../theme.dart';

class ServiceCenter extends StatelessWidget {
  const ServiceCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarBack(title: "고객센터"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.only(bottom: 15, top: 15, left: 15, right: 15),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    // const Text("원하시는 은행명을 남겨주시면 빠른 시일 내에 \n업데이트하겠습니다.", style: AppTheme.service_center,),
                    const Text("궁금하신 사항을 문의로 남겨주시면\n하루 이내로 빠른 답변을 받을 수 있습니다.", style: AppTheme.service_center,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    const Text("운영시간은 평일 10:00~18:00입니다.", style: AppTheme.service_center_blue,)
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: OutlinedButton(
                    onPressed: () async{

                      Uri url = await TalkApi.instance.addChannelUrl('_nvExoxb');
                      //await TalkApi.instance.channelChatUrl('_ZeUTxl');

                      // 연결 페이지 URL을 브라우저에서 열기
                      try {
                        await launchBrowserTab(url);
                      } catch (error) {
                        print('카카오톡 채널 추가 실패 $error');
                      }

                    },
                    child: const Text('카카오톡 1:1 문의하기', style: TextStyle(color: Color(0xFF381e1f), fontWeight: FontWeight.bold),),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFffdc00),
                        side: const BorderSide(color:Color(0xFFffdc00))
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}
