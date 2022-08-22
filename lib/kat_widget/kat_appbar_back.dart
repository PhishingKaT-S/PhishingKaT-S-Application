import 'package:flutter/material.dart';

import '../Theme.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget{
  const AppBarBack({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.blueText),),
      backgroundColor: AppTheme.blueBackground,
      centerTitle: true,
    );
  }
}
