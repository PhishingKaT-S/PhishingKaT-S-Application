import  'package:flutter/material.dart';

AppBar certification_appbar(Color c1, Color c2) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Icon(Icons.circle, color: c1, size: 10.0),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Icon(Icons.circle, color: c2, size: 10.0),
      )
    ],
  );
}