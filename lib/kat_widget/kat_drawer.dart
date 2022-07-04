import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/theme.dart';

class KaTDrawer extends StatelessWidget {
  const KaTDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: const [
          UserAccountsDrawerHeader(
              accountName: Text(
                "provider로 동적으로 이름 할당",
                style: AppTheme.title,
              ),
              accountEmail: Text(
                "email",
                style: AppTheme.body1,
              ))
        ],
      ),
    );
  }
}
