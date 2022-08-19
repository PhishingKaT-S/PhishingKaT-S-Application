/*
* write: Jiwon Jung
* date: 7.26
* description: 0.3 authority request
* 8/6: trying to acquire the authority
* */

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../kat_widget/launch_bottombar.dart';
import 'phone_certification.dart';

import '../Theme.dart';

/*
* 권한을 요청하는 UI이고 이 다음에
* Phone_certification으로 넘거간다.
* */
class AccessAuthority extends StatelessWidget {
  const AccessAuthority({Key? key}) : super(key: key);

  Flexible _callHistory() {
    return Flexible(
        flex: 3,
        child: Row(children: [
          expanded_sizedBox(),
          Expanded(
            flex: 6,
            child: Text(
              '통화기록',
              style: AppTheme.title,
            ),
          ),
          expanded_sizedBox()
        ]));
  }

  Flexible _contactCaption() {
    return Flexible(
        flex: 3,
        child: Row(children: [
          expanded_sizedBox(),
          Expanded(
            flex: 6,
            child: Text(
              '연락처 등록, 정보보기 변경',
              style: AppTheme.body1,
            ),
          ),
          expanded_sizedBox()
        ]));
  }

  Flexible _contact() {
    return Flexible(
        flex: 3,
        child: Row(children: [
          expanded_sizedBox(),
          Expanded(
            flex: 6,
            child: Text(
              '주소록',
              style: AppTheme.title,
            ),
          ),
          expanded_sizedBox()
        ]));
  }

  Flexible _phoneCaption() {
    return Flexible(
        flex: 3,
        child: Row(children: [
          expanded_sizedBox(),
          Expanded(
            flex: 6,
            child: Text(
              '번호 식별, 가입자 승인 시',
              style: AppTheme.body1,
            ),
          ),
          expanded_sizedBox()
        ]));
  }

  Flexible _phone() {
    return Flexible(
        flex: 3,
        child: Row(children: [
          expanded_sizedBox(),
          Expanded(
            flex: 6,
            child: Text(
              '전화',
              style: AppTheme.title,
            ),
          ),
          expanded_sizedBox()
        ]));
  }

  Flexible _servicelimitText() {
    return Flexible(
      flex: 3,
      child: Row(
        children: [
          expanded_sizedBox(),
          _serviceLimit(), //Text,
          expanded_sizedBox()
        ],
      ),
    );
  }

  Flexible _titleText() {
    return Flexible(
      flex: 4,
      child: Row(
        children: [expanded_sizedBox(), _title(), expanded_sizedBox()],
      ),
    );
  }

  Expanded _serviceLimit() {
    return Expanded(
      flex: 6,
      child: Text(
        '허용하지 않아도 앱 사용은 가능하나\n일부 서비스에 제한이 있을 수 있습니다.',
        style: AppTheme.serviceLimit,
      ),
    );
  }

  Expanded _title() {
    return Expanded(
      flex: 6,
      child: Text(
        '피싱캣S 서비스 이용을 위해 \n'
        '권한을 허용해주세요',
        style: AppTheme.serviceAuth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        /*
      * 해야할 것 bottombutton을 누를 때 권한 요청하는 ui가 필요함.
      * */
        Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        child: bottomBar(
            title: '확인',
            onPress: () async {
              Map<Permission, PermissionStatus> statuses = await [
                Permission.contacts,
                Permission.phone,
                Permission.sms,
                Permission.phone
              ].request();
              if (statuses[Permission.contacts]!.isGranted &&
                  statuses[Permission.sms]!.isGranted &&
                  statuses[Permission.phone]!.isGranted) {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (PhoneCRT())));
              } else {
                openAppSettings();
              }
            }),
      ), // button '확인'
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
              flex: 5,
              child: Row(
                children: [
                  expanded_sizedBox(),
                  Container(
                    color: Colors.white,
                  ),
                  expanded_sizedBox()
                ],
              )), // 윗공백

          _titleText(), //피싱캣 서비스를 위해 해주세요

          SizedBox(height: 10),

          _servicelimitText(), //밑의 캡션

          SizedBox(height: 30), //간격 조정

          _phone(), //전화

          SizedBox(
            height: 5,
          ),

          _phoneCaption(), //번호 식별, 가입자 승인시

          SizedBox(height: 20),

          _contact(), //주소록

          SizedBox(
            height: 5,
          ),

          _contactCaption(),

          SizedBox(height: 20),

          _callHistory(), //통화기록

          SizedBox(
            height: 5,
          ),

          Flexible(
              flex: 3,
              child: Row(children: [
                expanded_sizedBox(),
                Expanded(
                  flex: 6,
                  child: Text(
                    '통화기록 보기, 변경',
                    style: AppTheme.body1,
                  ),
                ),
                expanded_sizedBox()
              ])), //통화기록 보기, 변경
        ],
      ), // 위젯 트리 작성
    );
  }
}

// 사이 간격 조절하는 위젯
Widget expanded_sizedBox() {
  return Expanded(
      child: // 간격 맞추기
          SizedBox(),
      flex: 1);
}
