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
            Center(child: Image.asset('assets/images/no_smish_data.png')),
            SizedBox(height:10),
            Text('해당하는 스미싱 의심 기록이 없어요', style: AppTheme.menu_list)
          ],
        ),
      )
    );
  }
}
