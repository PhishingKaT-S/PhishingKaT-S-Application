/*
* writer Jiwon Jung
* date: 7/26
* description: writing 0.2, 0.21
* */
import 'package:flutter/material.dart';
import '../Theme.dart';

class Service extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: ServiceWidget(serviceTitle: '서비스 이용 약관',conText: '제 1조 1항')
      );
  }
}

class ServiceWidget extends StatelessWidget {
  late String serviceTitle; //서비스 이용 약관
  late String conText;  //제 1조 1항
  String conTent='피싱캣S 서비스 이용자 여러분 반갑습니다! \n피싱캣S 서비스를 이용해 주셔서 감사합니다. 여러분이 이용하시면서 필요하시거나 궁금해하실 기본적인 서비스 이용 관련 정보를 약관에 담아 안내드립니다. 약관을 통해 AI굿윌보이스(이하 “회사”)와 회원(이하 ‘회원’)과의 권리, 의무 및 책임사항, 기타 사항을 확인하실 수 있으며 회사는 이 약관의 내용을 여러분이 쉽게 확인할 수 있도록 서비스 초기 화면에 게시합니다. 회사는 안정적인 서비스를 지속적으로 제공하기 위해 최선을 다해 노력해 나갈 것이며, 여러분이 조금만 시간을 내서 약관을 읽어주신다면, 여러분과 더욱 가까운 사이가 될 것이라고 믿습니다.\n\n약관에서 사용되는 용어의 정의와 해석은 다음과 같습니다.\n“회원”은 본 약관 및 개인정보처리방침에 동의하고 서비스 이용 자격을 부여 받은 자를 의미합니다.\n“서비스”는 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 상관없이 회원이 이용할 수 있는 피싱캣S 및 피싱캣S 관련 제반 서비스를 의미합니다.\n“계정(ID)”은 회원의 식별과 서비스 이용을 위하여 회원이 정하는 문자, 숫자, 특수문자의 조합을 의미합니다.\n\n회사는 약관의 내용을 회원이 쉽게 알 수 있도록 게시하며, 사전 공지 후 개정합니다. 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스초기 화면 및 별도의 연결화면 또는 팝업화면 등에 게시합니다. 또한, 관련법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. 약관을 개정할 경우에는 적용일자 및 개정사유 등을 명시하여 그 적용일자로부터 최소한 7일 이전(회원에게 불리하거나 중대한 사항의 변경은 30일 이전)부터 그 적용일자 경과 후 상당한 기간이 경과할 때까지 서비스에 게시합니다. 약관 개정 공지일로부터 개정약관 시행일 7일 후까지 본 개정약관에 대한 거부의사를 표시하지 않으면 개정약관에 동의한 것으로 봅니다. 개정약관의 적용에 동의하지 않는 경우 회원은 이용계약을 해지할 수 있습니다.\n\n약관과 기타약관은 상호 보완됩니다.\n회사는 유료서비스 및 개별 서비스에 대해서는 별도의 이용약관 및 정책(이하 “기타 약관 등”)을 둘 수 있습니다. 이 약관에서 정하지 아니한 사항이나 해석에 대해서는 “기타 약관” 및 관계법령 또는 상관례에 따릅니다.\n'
      '';  //진짜 내용
  ServiceWidget({
    Key? key,
    required String serviceTitle,
    required String conText,
  }){
    this.serviceTitle = serviceTitle;
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
            title:Text(serviceTitle, style: AppTheme.body1),
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
