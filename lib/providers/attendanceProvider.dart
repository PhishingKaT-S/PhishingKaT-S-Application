// import 'package:flutter/cupertino.dart';
// import 'package:mysql1/mysql1.dart';
// import 'package:phishing_kat_pluss/providers/launch_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../db_conn.dart';
//
// class AttendanceProvider extends ChangeNotifier{
//   AttendanceProvider(){
//     _init();
//   }
//
//   void _init(){
//
//   }
//
//   late DateTime recent_attendance;
//
//   void getRecentAttendance() async{
//     await MySqlConnection.connect(Database.getConnection()).then((conn) async {
//       await conn.query(
//           "SELECT attendance FROM attendance WHERE user_id = ?",
//           [Provider<LaunchProvider>.,]).then((results) {
//         if (results.isNotEmpty) {
//           if (results.length > 1) {
//           } else {
//           }
//         } else if (results.isEmpty) {
//         }
//       }).onError((error, stackTrace) {
//         print("error: $error");
//       });
//       conn.close();
//     }).onError((error, stackTrace) {
//       print("error2: $error");
//     });
//   }
// }