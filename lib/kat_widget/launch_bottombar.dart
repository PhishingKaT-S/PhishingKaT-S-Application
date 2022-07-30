/*
* write: Jiwon Jung
* date: 7/26
* content: bottom bar(title),
* when the title in then return the bottom button
* */

import 'package:flutter/material.dart';

import '../../Theme.dart';

//
Widget bottomBar({required String title, required void onPress()}) {
  String _title = title;
  return Container(
    width: double.infinity,
    height: 50,
    child: TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.startBackground)),
      onPressed: () {
        onPress();
        //여기에 detailed info로 넘어가야됨
      },
      child: Text(_title, style: AppTheme.title),
    ),
  );
}