import  'package:flutter/material.dart';

AppBar certification_appbar(Color c1, Color c2) {
  return AppBar(
    leading: Container(color: Colors.white),
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 7.0),
        child: Icon(Icons.circle, color: c1, size: 10.0),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 14.0),
        child: Icon(Icons.circle, color: c2, size: 10.0),
      )
    ],
  );
}