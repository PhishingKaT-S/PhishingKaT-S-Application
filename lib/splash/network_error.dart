import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kat_pages/home_page.dart';
import '../launch/login_page.dart';
import '../providers/launch_provider.dart';

class NetworkError extends StatefulWidget {
  const NetworkError({Key? key}) : super(key: key);

  @override
  State<NetworkError> createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return const networkErrorMain();
  }
}

// ignore: camel_case_types
class networkErrorMain extends StatelessWidget {
  const networkErrorMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/network_error.png',
              height: 105.4,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '네트워크가 불안정합니다',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 17,
            ),
            const Text(
              '네트워크 연결에 실패했습니다\n 확인 후 다시 시도해주세요',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const SizedBox(
              height: 80,
            ),
            OutlinedButton(
              child: const Text(

                '다시 시도하기',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0473e1),
                    fontWeight: FontWeight.w800),
              ),
              onPressed: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.none) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("네트워크 연결이 없습니다."),
                      duration: Duration(seconds: 2)));
                } else if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
                  // I am connected to a wifi network.
                  int result = await Provider.of<LaunchProvider>(context, listen: false).Init();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => result== 1? const HomePage() : const LoginPage()), (route) => false);

                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("무슨 경우야"),
                      duration: Duration(seconds: 2)));
                }
              },
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0372e0), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: const Size(208, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
