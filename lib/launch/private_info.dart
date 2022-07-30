/*
* writer Jiwon Jung
* date: 7/26
* description: writing 0.2, 0.21
* */

import 'package:flutter/material.dart';
import '../Theme.dart';

class privateinfo extends StatelessWidget {
  const privateinfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: PolicyWidget(policyTitle: '서비스 이용 약관',conText: '제 1조 1항')
      );
  }
}
/*
* 해야할 것
* Style 교체 및 약관 내용 수정
* */
class PolicyWidget extends StatelessWidget {
  late String policytitle; //서비스 이용 약관
  late String conText;  //제 1조 1항
  String conTent='피싱캣S 서비스 이용자 여러분 반갑습니다! \n피싱캣S 서비스를 이용해 주셔서 감사합니다. 여러분이 이용하시면서 필요하시거나 궁금해하실 기본적인 서비스 이용 관련 정보를 약관에 담아 안내드립니다. 약관을 통해 AI굿윌보이스(이하 “회사”)와 회원(이하 ‘회원’)과의 권리, 의무 및 책임사항, 기타 사항을 확인하실 수 있으며 회사는 이 약관의 내용을 여러분이 쉽게 확인할 수 있도록 서비스 초기 화면에 게시합니다. 회사는 안정적인 서비스를 지속적으로 제공하기 위해 최선을 다해 노력해 나갈 것이며, 여러분이 조금만 시간을 내서 약관을 읽어주신다면, 여러분과 더욱 가까운 사이가 될 것이라고 믿습니다.\n\n약관에서 사용되는 용어의 정의와 해석은 다음과 같습니다.\n“회원”은 본 약관 및 개인정보처리방침에 동의하고 서비스 이용 자격을 부여 받은 자를 의미합니다.\n“서비스”는 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 상관없이 회원이 이용할 수 있는 피싱캣S 및 피싱캣S 관련 제반 서비스를 의미합니다.\n“계정(ID)”은 회원의 식별과 서비스 이용을 위하여 회원이 정하는 문자, 숫자, 특수문자의 조합을 의미합니다.\n\n회사는 약관의 내용을 회원이 쉽게 알 수 있도록 게시하며, 사전 공지 후 개정합니다. 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스초기 화면 및 별도의 연결화면 또는 팝업화면 등에 게시합니다. 또한, 관련법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. 약관을 개정할 경우에는 적용일자 및 개정사유 등을 명시하여 그 적용일자로부터 최소한 7일 이전(회원에게 불리하거나 중대한 사항의 변경은 30일 이전)부터 그 적용일자 경과 후 상당한 기간이 경과할 때까지 서비스에 게시합니다. 약관 개정 공지일로부터 개정약관 시행일 7일 후까지 본 개정약관에 대한 거부의사를 표시하지 않으면 개정약관에 동의한 것으로 봅니다. 개정약관의 적용에 동의하지 않는 경우 회원은 이용계약을 해지할 수 있습니다.\n\n약관과 기타약관은 상호 보완됩니다.\n회사는 유료서비스 및 개별 서비스에 대해서는 별도의 이용약관 및 정책(이하 “기타 약관 등”)을 둘 수 있습니다. 이 약관에서 정하지 아니한 사항이나 해석에 대해서는 “기타 약관” 및 관계법령 또는 상관례에 따릅니다.\n'
     + '서비스의 실제 이용까지는 몇가지 절차가 필요합니다.\n'+
  '회사가 제공하는 서비스를 이용하고자 하는 자는 이용약관 및 개인정보처리방침에 동의하는 방법으로 이용 신청을 하고, 회사가 이러한 신청에 대하여 승낙함으로써 체결됩니다. 회사는 회사가 이용자에게 요구하는 정보에 대해 이용자가 정보를 정확히 기재하여 이용신청을 한 경우에 상당한 이유가 없는 한 이용신청을 승낙합니다. 이용신청에 있어 회사는 전문기관을 통한 실명인증 및 본인인증을 요청할 수 있습니다. 다만, 회사는 다음 몇가지 경우에 대하여 승낙을 하지 않거나 사후에 이용계약을 해지할 수 있습니다.\n'+
  '첫번째, 이용신청자가 이 약관에 의해 이전에 회원자격을 상실한 적이 있는 경우, 단 회사의 회원 재가입 승낙을 얻은 경우에는 예외로 처리 합니다.\n'+
  '두번째, 실명이 아니거나, 타인의 명의를 이용한 경우입니다.\n'+
  '세번째, 이미 가입된 회원의 정보와 동일한 경우(단말기정보, 전화번호, 전자우편 계정 등)입니다.\n'+
  '네번째, 허위 정보를 기재하거나, “회사”가 제시하는 내용을 기재하지 않는 경우입니다.\n'+
  '다섯번째, 14세 미만 아동이 법정대리인(부모 등)의 동의를 얻지 아니한 경우입니다.\n'+
  '마지막으로 타인의 명예훼손을 한 경우 입니다.\n';  //진짜 내용




  PolicyWidget({
    Key? key,
    required String policyTitle,
    required String conText,
  }){
    this.policytitle = policyTitle;
    this.conTent = conTent;
    this.conText = conText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child:AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title:Text(policytitle, style: AppTheme.body1),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.check, color: Colors.blue,))
          ]
          ,
        )
      ),
      body: SingleChildScrollView(
        child:
          Container(
            color: Colors.white,
            child: Column(
                            children:<Widget>[

                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right:8.0),
                            child: Text(conText, style: AppTheme.title,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(conTent, style: AppTheme.body1),
                          )
                        ],
                      ),
          ),
        ),

      );
  }
}
/*
피싱캣S 서비스 이용자 여러분 반갑습니다!\n
피싱캣S 서비스를 이용해 주셔서 감사합니다. 여러분이 이용하시면서 필요하시거나 궁금해하실 기본적인 서비스 이용 관련 정보를 약관에 담아 안내드립니다. 약관을 통해 AI굿윌보이스(이하 “회사”)와 회원(이하 ‘회원’)과의 권리, 의무 및 책임사항, 기타 사항을 확인하실 수 있으며 회사는 이 약관의 내용을 여러분이 쉽게 확인할 수 있도록 서비스 초기 화면에 게시합니다. 회사는 안정적인 서비스를 지속적으로 제공하기 위해 최선을 다해 노력해 나갈 것이며, 여러분이 조금만 시간을 내서 약관을 읽어주신다면, 여러분과 더욱 가까운 사이가 될 것이라고 믿습니다.\n
\n
약관에서 사용되는 용어의 정의와 해석은 다음과 같습니다.\n
“회원”은 본 약관 및 개인정보처리방침에 동의하고 서비스 이용 자격을 부여 받은 자를 의미합니다.\n
“서비스”는 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 상관없이 회원이 이용할 수 있는 피싱캣S 및 피싱캣S 관련 제반 서비스를 의미합니다.\n
“계정(ID)”은 회원의 식별과 서비스 이용을 위하여 회원이 정하는 문자, 숫자, 특수문자의 조합을 의미합니다.\n
\n
회사는 약관의 내용을 회원이 쉽게 알 수 있도록 게시하며, 사전 공지 후 개정합니다. 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스초기 화면 및 별도의 연결화면 또는 팝업화면 등에 게시합니다. 또한, 관련법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. 약관을 개정할 경우에는 적용일자 및 개정사유 등을 명시하여 그 적용일자로부터 최소한 7일 이전(회원에게 불리하거나 중대한 사항의 변경은 30일 이전)부터 그 적용일자 경과 후 상당한 기간이 경과할 때까지 서비스에 게시합니다. 약관 개정 공지일로부터 개정약관 시행일 7일 후까지 본 개정약관에 대한 거부의사를 표시하지 않으면 개정약관에 동의한 것으로 봅니다. 개정약관의 적용에 동의하지 않는 경우 회원은 이용계약을 해지할 수 있습니다.\n
\n
약관과 기타약관은 상호 보완됩니다.\n
회사는 유료서비스 및 개별 서비스에 대해서는 별도의 이용약관 및 정책(이하 “기타 약관 등”)을 둘 수 있습니다. 이 약관에서 정하지 아니한 사항이나 해석에 대해서는 “기타 약관” 및 관계법령 또는 상관례에 따릅니다.\n
\n
'서비스의 실제 이용까지는 몇가지 절차가 필요합니다.\n
회사가 제공하는 서비스를 이용하고자 하는 자는 이용약관 및 개인정보처리방침에 동의하는 방법으로 이용 신청을 하고, 회사가 이러한 신청에 대하여 승낙함으로써 체결됩니다. 회사는 회사가 이용자에게 요구하는 정보에 대해 이용자가 정보를 정확히 기재하여 이용신청을 한 경우에 상당한 이유가 없는 한 이용신청을 승낙합니다. 이용신청에 있어 회사는 전문기관을 통한 실명인증 및 본인인증을 요청할 수 있습니다. 다만, 회사는 다음 몇가지 경우에 대하여 승낙을 하지 않거나 사후에 이용계약을 해지할 수 있습니다.\n'
첫번째, 이용신청자가 이 약관에 의해 이전에 회원자격을 상실한 적이 있는 경우, 단 회사의 회원 재가입 승낙을 얻은 경우에는 예외로 처리 합니다.\n
두번째, 실명이 아니거나, 타인의 명의를 이용한 경우입니다.\n
세번째, 이미 가입된 회원의 정보와 동일한 경우(단말기정보, 전화번호, 전자우편 계정 등)입니다.\n
네번째, 허위 정보를 기재하거나, “회사”가 제시하는 내용을 기재하지 않는 경우입니다.\n
다섯번째, 14세 미만 아동이 법정대리인(부모 등)의 동의를 얻지 아니한 경우입니다.\n
마지막으로 타인의 명예훼손을 한 경우 입니다.\n'
또한, 회사의 설비에 여유가 없거나 기술상 또는 업무상 문제가 있는 경우나 서비스 상의 장애 또는 서비스 이용요금 결제수단의 장애가 발생한 경우 등에는 승낙을 유보할 수 있습니다.\n
\n
여러분의 개인정보를 보호하기 위해 노력합니다.\n
\n
회사는 서비스 내에서 회원이 이용하는 서비스에 대한 내용을 저장ㆍ보관할 수 있습니다. (위캣은 모바일 관련 서비스로 수발신 내역 등을 포함합니다.)  그리고, 회원간의 분쟁 조정, 민원 처리 등을 위하여 회사가 필요하다고 판단하는 경우에 한하여 본 정보를 열람하도록 할 것이며, 본 정보는 회사만이 보유하고 법령으로 권한을 부여 받지 아니한 제3자는 절대로 열람할 수 없습니다. 다만, 앱 이용 중 공유 정보 기능을 통해서 다른 사람들의 정보가 보여질 수도 있습니다.  회사는 주기적으로 회원정보 및 발신자 ID를 업데이트하고 있으며, 회원 또는 제3자의 생성정보(스팸정보, 안심정보, 공유정보 등)가 객관성과 공정성을 유지하도록 하기 위하여 노력합니다.\n
\n
회사는 특정 생성정보가 허위 또는 과장된 정보이거나, 해당 정보의 공유가 회원 또는 제3자의 개인정보를 침해하는 것으로서 이로 인하여 피해가 발생할 우려가 있는 경우에는 해당 생성정보를 숨기거나 삭제할 권리가 있습니다. 특정 생성정보에 관하여 회원 또는 제3자로부터 불만사항이 제기된 경우, 회사는 관련 내용의 확인 및 검토를 통해서 30일 내에 해당 생성정보를 수정하거나 삭제할 수 있습니다. 그럼에도 불구하고 해당 정보에 대한 논쟁의 여지가 있다면 서비스를 통해 계속 정보가 노출될 것이며, 회사는 해당 정보의 수정 및 삭제에 대한 보증을 하지 않습니다. 회원 개인정보의 보호 및 사용에 대해서는 관계법령 및 회사가 별도로 고지하는 개인정보취급방침이 적용되며, 회사는 관계 법령이 정하는 바에 따라 계정정보를 포함한 회원의 개인정보를 보호하기 위해 노력합니다. 또한, 회사는 회원의 귀책사유로 인하여 노출된 회원의 계정정보를 포함한 모든 정보에 대해서 일체의 책임을 지지 않습니다.\n
\n
서비스 사용과 관련해서 주의사항이 요구됩니다.\n
이용자분들은 서비스의 올바른 활용을 위해 다음 행동이 금지됩니다.\n
\n
신청 또는 변경 시 허위내용을 기재하는 것, 타인의 정보를 도용하는 것, 다른 회원의 개인정보 및 계정정보를 수집하는 행위, 회사가 금지한 정보(컴퓨터 프로그램 등)의 송신 또는 게시하는 것, 회사와 기타 제3자의 저작권 등 지적재산권에 대한 침해 행위, 회사 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위, 외설 또는 폭력적인 말이나 글, 화상, 음향, 기타 공서양속에 반하는 정보를 공개 또는 게시하는 행위, 회사의 동의 없이 영리, 영업, 광고를 목적으로 서비스를 사용하는 행위, 리버스엔지니어링, 디컴파일, 디스어셈블 및 기타 일체의 가공행위를 통하여 서비스를 복제, 분해 또는 모방 기타 변형하는 행위, 기타 관련 법령에서 금지하거나 선량한 풍속 기타 사회통념상 허용되지 않는 행위 등이 이에 해당합니다.\n
\n
또, 회원은 회사의 사전승인 없이 서비스를 이용하여 상품 재 판매, 상품 광고, 음란정보 등의 정보를 게시하거나 제 3자의 영업을 방해하는 행위, 제3자에 대한 허위사실 명기 및 명예훼손 등 제3자의 권리를 침해하는 행위를 할 수 없습니다. 이를 위배하여 발생한 활동의 결과 및 손실, 관계기관에 의한 법적 조치 등에 관해서는 회사가 책임지지 않습니다.\n
\n
만일 회원의 위반행위로 인하여 회사 및 제 3자에게 손해가 발생한 경우 회원은 회사 및 제 3자가 입은 피해를 배상해야 합니다. 또한 회원의 위반행위로 인하여 제3자가 입은 손해에 대해 회사가 이를 제 3자에게 배상한 경우, 회사는 회원을 상대로 구상권을 행사할 수 있습니다.\n
\n
이 약관의 규정, 이용안내 및 서비스와 관련하여 공지한 주의사항, 회사가 통지하는 사항 등을 확인하고 준수할 의무가 있으며, 기타 회사의 업무에 방해되는 행위를 하여서는 안됩니다.\n
\n
안정적 서비스 제공을 위해 노력합니다.\n
서비스는 연중무휴, 1일 24시간 무 중단 제공을 원칙으로 합니다.\n
다만, 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 정기점검, 통신두절 또는 운영상 상당한 이유가 있는 경우나 해킹 등의 전자적 침해사고, 통신사고, 미처 예상하지 못한 서비스의 불안정성에 대응하기 위하여 필요한 경우, 천재지변, 비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 제공이 불가능할 경우와 회사의 분할, 합병, 영업양도, 영업의 폐지, 당해 서비스의 사업구조 악화 등 회사의 경영상 중대한 필요에 의한 경우 등의 이유로 서비스가 제공되지 않을 수 있습니다. 해당하는 사유로 서비스가 중단될 경우 사전에 회원에게 통지합니다. 다만, 회사가 사전에 통지할 수 없는 부득이한 사정이 있는 경우는 사후에 통지를 할 수 있습니다.\n
\n
다양한 정보를 제공할 수 있습니다.\n
\n
회사는 회원이 서비스 이용 중에 필요하다고 인정되는 다양한 정보를 전자우편, 모바일 어플리케이션 PUSH알림, SMS등의 방법을 통해 회원에게 제공할 수 있으며, 회원은 관련법에 따른 거래관련 정보 및 고객문의 등에 대한 답변 등을 제외하고는 언제든지 수신을 거절할 수 있습니다. 회사가 회원에 대하여 제공하는 정보는 다음과 같습니다.\n
1. 회원이 특정 업체에 전화를 발신한 경우 해당 업체의 위치에 대한 검색결과를 회원에게 PUSH 알림으로 제공\n
2. 회원이 특정 업체의 이름으로 저장된 전화번호로 발신하는 경우, 해당 업체의 홈페이지로 연결되는 링크를 PUSH 알림으로 제공\n
모바일 어플리케이션 PUSH알림은 서비스 상 의무적으로 안내되어야 하는 정보성 내용에 한하여 발송합니다. 회원은 PUSH 알림에 대하여 수신을 거절할 수 있습니다.\n
회사의 이용자의 메시지 내 포함된 URL이나 계좌번호 및 “입금”,”광고” 등의 특정 키워드를 분석하여 URL스미싱 및 이상 거래 계좌번호 조회를 통한 범죄 예방 정보를 제공합니다.\n
회사는 특정 키워드 분석을 위해 메시지에 해당 키워드가 포함되어 있는지 여부를 로직으로 탐지하여 정보를 제공하며 메시지 내용 전체를 조회하지 않습니다.\n
안전안심 서비스를 제공할 수 있습니다.\n
\n
본 서비스는 회원에게 금융피해가 발생할 것으로 의심되는 정보를 제공하는 생활 편의 서비스이며, 인명이나 재산 보호를 목적으로 하지 않습니다.\n
1. 안심이 서비스\n
본 서비스는 해당 약관에 동의한 전화번호로 로그인 된 회원의 위험상황 탐지 시 단말에 경고음을 출력하고, 회원이 등록한 상대에게 위험상황을 공유할 수 있습니다.회사는 위험상황 탐지를 위해 이용자 단말기에서 일어나는 활동 분석을 할 수 있습니다. 이를 통해 보이스피싱을 비롯한 금융사기를 탐지하고 피해를 예방하기 위한 알림을 제공합니다.\n
첫번째, 회원의 위험상황이 탐지된 경우 회원에게 AI 보안관이 경고음으로 알림을 제공할 수 있습니다.\n
두번째, 회원의 위험상황이 탐지된 경우 회원이 등록한 상대에게 PUSH 알림 및 메시지로 위험상황을 공유할 수 있습니다.\n
AI 보안관 서비스는 기본으로 활성화되어 제공되는 서비스입니다. 단, 회원이 AI 보안관 서비스의 차단을 원할 경우에 안심이 설정에서 AI 보안관 서비스의 제한을 선택할 수 있습니다.\n
군인회원의 경우, 별도 웹사이트에서 군인가족회원이 군인회원의 전화번호를 등록할 경우 안심이 상대방 등록 알림을 받을 수 있습니다.\n
다양한 광고를 제공할 수 있습니다\n
회사는 서비스 운영과 관련하여 서비스 화면, 홈페이지, 전자우편 등에 광고를 게재할 수 있으며, 회원은 광고가 게재된 전자우편에 대해서는 수신을 거절할 수 있습니다. 광고성 정보는 사전에 마케팅 정보 수신 동의를 한 회원에게만 발송됩니다. 회원은 정보성 알림과 광고가 게재된 광고성 PUSH알림에 대해서 수신을 거절 할 수 있습니다. 광고를 게재할 수 있는 서비스 화면은 후후 서비스를 통해 실행되는 전화 수신/발신화면, 통화 종료화면, 부재중 통화화면, 문자 수신화면 등의 영역을 포함합니다. 또한 회사가 회원에게 발송하는 광고는, 회원이 특정 업체에서 제공하는 상품의 이름으로 저장된 전화번호로 발신하는 경우 해당 상품 소개 홈페이지로 연결되는 링크를 발송하거나, 회원의 휴대전화에 특정 앱이 설치되어 있는지 여부를 확인한 후(이 과정에서 회사는 개인정보 보호에 관한 제반규정을 준수합니다) 해당 전화번호에 대하여 문자 또는 전화가 수신될 때 해당 앱과 관련된 업체에 대한 광고를 배너 형태로 노출하는 등 다양한 방식으로 발송됩니다. 또한, 회사는 키워드를 활용한 개인 맞춤형 정보와 광고를 게재할 수 있습니다. 즉, 회사는 회원이 수신한 문자 내용에 특정 키워드가 포함되어 있는지 여부만을 확인하고, 확인된 키워드를 해시태그 형태로 문자 알림창 하단에 표출한 후, 해시태그를 클릭할 때 해당 키워드에 대한 검색결과 페이지로 이동할 수 있도록 하는 서비스를 제공합니다. 회원은 본 이용약관의 내용에 동의함으로써 회사가 위 서비스를 회원에게 제공하는 것에 관하여 동의하며, 언제든지 위 동의를 철회할 수 있습니다.\n
유료서비스를 제공할 수 있습니다.\n
회사는 무료로 서비스를 제공하고 있으나, 일부 서비스의 경우 유료로 제공할 수 있습니다. 예를 들면 광고가 포함된 후후는 무료이나, 광고 없는 후후 등은 유료로 이용해야 합니다. 유료서비스의 명칭, 내용, 이용방법, 이용료, 환불 방법 등 이용과 관련한 사항을 유료서비스 안내 페이지 내에 회원이 알기 쉽게 표시합니다. 회사는 결제의 이행을 위하여 반드시 필요한 여러분의 개인정보를 추가적으로 요구할 수 있으며, 여러분은 회사가 요구하는 개인정보를 정확하게 제공해야 합니다. 각 유료서비스마다 결제 방법의 차이가 있을 수 있으며, 매월 정기적인 결제가 이루어지는 서비스의 경우 여러분 개인이 해당 서비스의 이용을 중단하고 정기 결제의 취소를 요청하지 않는 한 매월 결제가 이루어집니다. 유료서비스 결제는 앱마켓 등을 통한 인앱결제를 통해서만 이루어지며, 유료서비스의 결제 또는 과오납금의 환불, 이용계약의 해제 또는 해지, 서비스의 결함으로 인하여 발생하는 손해의 보상 등에 관하여는 결제가 이루어지는 해당 앱마켓의 이용약관 규정이 적용됩니다.\n
\n
서비스에 대한 권리를 존중해 주시기 바랍니다.\n
회원이 서비스 내에서 작성한 게시물에 대한 모든 권리 및 책임은 이를 게시한 회원에게 있으며, 회사는 회원이 작성한 게시물이 다른 회원 또는 제 3자를 비방하거나 중상모략, 허위정보 등으로 명예훼손 및 영업방해를 하는 내용이거나, 공공질서 및 미풍양속에 위반되는 내용의 경우 해당 게시물을 삭제 할 수 있습니다.\n
또한 범죄적 행위에 결부된다고 인정되는 경우, 회사의 저작권 또는 제 3자의 저작권 등 기타 권리를 침해하는 내용인 경우, 회원이 서비스에 음란물을 게재하거나 음란사이트를 링크하는 경우, 회사로부터 사전에 승인 받지 아니한 상업광고, 판촉 내용을 게시하는 경우, 정당한 사유 없이 회사의 영업을 방해하는 내용을 게재하는 경우, 기타 관계법령에 위반된다고 판단되는 경우에도 삭제가 가능합니다. 이에 대하여 회사는 어떠한 책임도 지지 않습니다.\n
만약 회원의 위반행위로 인하여 제3자가 입은 손해에 대해 회사가 이를 제3자에게 배상한 경우, 회사는 회원을 상대로 구상권을 행사할 수 있습니다.\n
게시물은 「정보통신망이용촉진 및 정보보호 등에 관한 법률」 및 「저작권법」 등 관련법에 위반되는 내용을 포함하는 경우, 권리자는 관련법이 정한 절차에 따라 해당 게시물의 게시를 중단하거나 삭제를 요청할 수 있으며, 관련법에 따라 조치를 취할 수 있습니다. 회사는 회원이 작성한 게시물을 서비스 제휴업체에 제공할 수 있습니다.\n
서비스에 대한 저작권 및 지적재산권은 회사의 소유입니다. 다만, 사업 제휴에 따라 제공받은 저작물은 제외합니다. 회원은 회사가 제공하는 서비스를 이용함으로써 얻은 정보 중 회사 또는 제공업체에 지적재산권이 귀속된 정보를 회사 또는 제공업체의 사전승낙 없이 복제, 전송, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다. 회원은 회사에서 정한 이용조건에 따라 계정(ID), 서비스 콘텐츠 등을 이용할 수 있는 이용권한만 부여 받습니다. 회원은 이를 양도, 판매, 담보제공 등의 처분행위를 할 수 없습니다.\n
\n
위치정보 활용 동의 및 철회는 언제든 가능합니다.\n
회사는 일부 서비스를 제공하기 위해 회원의 위치정보를 활용할 수 있습니다. 회원의 위치정보는 검색기능을 통해 특정상호 또는 전화번호로 정보를 검색할 때 활용됩니다. 회사는 서비스를 제공하는 과정에서 활용된 회원의 위치정보를 별도로 수집하지 않습니다. 활용되는 회원의 위치정보는 서비스를 이용하는 시점에 목적지까지의 거리 및 목적지의 위치 등의 정보를 검색하기 위해서만 활용됩니다.\n
회사는 회원에게 위치정보 활용에 대한 동의를 얻을 수 있습니다. 회원은 위치정보 활용을 원하지 않을 경우 위치정보 활용을 거절할 수 있습니다. 다만, 위치정보 활용에 동의하지 않은 경우에는 위치정보를 활용하여 제공되는 지도 및 거리순 정렬 서비스 등을 이용할 수 없습니다. 회원이 이미 동의한 위치정보 활용에 대해 동의를 철회하고자 할 경우에 단말기 기본설정에 위치정보 설정메뉴를 통하여 위치정보 활용에 대한 동의를 철회 할 수 있습니다.\n
\n
회사는 개인맞춤형 서비스의 이용과 관련하여 비식별화된 정보를 제3자에게 위탁합니다.\n
회사는 1) 후후 서비스 이용 고객의 통화 수발신 시간 정보 2) 후후 서비스 이용 고객의 수발신 상호 3) 후후 서비스 이용 고객의 수발신 위치정보 4) 후후 서비스 이용 고객의 수발신량의 정보를 비식별화 조치를 통하여 “개인 식별이 불가능한 정보”로 재생성 한 후 이를 회사와 제휴한 사업자에게 제공하고 회원은 이에 동의합니다. 만일 이에 동의하지 않을 경우 일부 서비스의 이용이 제한될 수 있습니다.\n
\n
원치 않으시면 해지하실 수 있습니다.\n
회원은 서비스 내 회원탈퇴 메뉴를 통하여 이용계약을 해지할 수 있으며, 서비스의 삭제 또는 1년간 서비스 이용내역이 없을 경우 계약이 해지됩니다. 회사는 관련법 등이 정하는 바에 따라 이를 처리합니다. 회원이 계약을 해지하는 경우 관련법 및 개인정보처리방침에 따라 회사가 회원정보를 보유하는 경우를 제외하고는 이용계약 해지와 함께 회원정보는 소멸됩니다. 다만, 회원이 계약을 해지하는 경우에 회원이 작성한 게시물은 삭제되지 않습니다.\n
\n
부득이하게 이용에 제한을 받으실 수 있습니다.\n
회사는 회원이 약관의 의무를 위반하거나 서비스의 정상적인 운영을 방해한 경우 경고, 계약해지 등 단계적으로 서비스 이용을 제한할 수 있습니다. 제한의 조건 및 세부내용은 회사의 이용제한정책 등에서 정한 바에 의합니다. 회사는 회원이 이 약관에서 정한 회원의 의무를 위반한 경우에는 회원에 대한 사전 통보 후 계약을 해지할 수 있습니다. 다만, 회원이 현행법 위반 및 고의 또는 중대한 과실로 회사에 손해를 입힌 경우에는 사전 통보 없이 이용계약을 해지할 수 있습니다. 회사가 이용계약을 해지하는 경우 회사는 회원에게 서면, 전자우편 또는 이에 준하는 방법으로 해지사유와 해지일을 회원에게 통보합니다. 회원은 본 조에 따른 이용제한 등에 대해 회사가 정한 절차에 따라 이의신청을 할 수 있습니다. 회사는 회원의 이의가 정당하다고 인정되는 경우 즉시 회원의 서비스 이용을 재개합니다. 서비스 이용을 제한하거나 계약을 해지하는 경우에는 회사는 통지 방식에 따라 알리게 되며 이 때 여러분은 회사가 정한 절차에 따라 이의신청을 할 수 있습니다. 이의가 정당하다고 회사가 인정하는 경우 회사는 즉시 서비스의 이용을 재개합니다.\n
\n
서비스 운영에 대한 책임 중 몇가지 예외 사항이 있습니다.\n
회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제되며, 회원의 귀책사유로 인한 서비스 이용의 장애 및 계약해지에 대하여 책임을 지지 않습니다. 또한 기간통신 사업자가 전기통신서비스를 중지하거나 정상적으로 제공하지 아니하여 회원에게 손해가 발생한 경우에 대해서 회사의 고의 또는 중대한 과실이 없는 한 책임이 면제됩니다. 회사 및 회사의 임직원 그리고 대리인은 회원의 신청정보 및 기타 정보(전화번호 상호정보 등)의 허위 또는 부정확성에 기인하는 손해, 그 성질과 경위를 불문하고 서비스에 대한 접속 및 서비스 이용과정에서 발생하는 개인적 손해, 서버에 대한 제3자의 모든 불법적인 접속 또는 서버의 불법적인 이용으로 발생하는 손해, 제3자가 서비스를 이용하여 불법적으로 전송, 유포하거나 또는 전송, 유포되도록 한 모든 바이러스, 스파이 웨어 및 기타 악성 프로그램으로 인한 손해, 전송된 데이터의 오류 및 생략, 누락, 파괴 등으로 발생되는 손해, 회원간 서비스 이용과정에서 발생하는 명예훼손 및 기타 불법행위로 인한 각종 민형사상 책임을 지지 않습니다. 또한 회원이 서비스와 관련하여 게재한 정보, 자료, 사실의 신뢰도, 정확성 등의 내용에 대해서는 보증하지 않으며, 회원 사이 또는 회원이 제3자와 상호간에 서비스를 매개로 하여 발생한 분쟁에 대해서는 개입할 의무가 없으며 책임이 면제됩니다. 그 밖에도 무료로 제공되는 서비스 이용과 관련하여 관련법에 특별한 규정이 없는 한 책임을 지지 않습니다.\n
\n
회원은 다음의 경우에 회사에 대하여 손해배상책임을 부담합니다.\n
“회사”는 “회원” 이 서비스를 이용함에 있어 회사의 고의 또는 과실로 인해 손해가 발생한 경우에는 민법 등 관련 법령이 규율 하는 범위 내에서 그 손해를 배상합니다.\n
“회원”은 이 약관을 위반하거나 관계법령을 위반하여 “회사”에 손해가 발생한 경우에는 “회사”에 그 손해를 배상하여야 합니다.\n
“회원”은 이 약관을 위반하거나 관계법령을 위반하여 제3자가 “회사”를 상대로 민형사상의 법적 조치를 취하는 경우, 자신의 비용과 책임으로 “회사”를 면책시켜야 하며, 이로 인해 발생하는 손해에 대해 배상하여야 합니다.\n*/