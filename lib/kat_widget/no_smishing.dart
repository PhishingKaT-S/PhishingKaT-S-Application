import 'package:flutter/material.dart';

import '../Theme.dart';

class noSmishing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height:100,
              child: Image.asset('assets/images/no_smish_data.png'),
            ),
            Text('해당하는 스미싱 의심 기록이 없어요', style: AppTheme.menu_list)
          ],
        ),
      )
    );
  }
}
