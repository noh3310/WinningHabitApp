import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winning_habit/view/setting/web_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white24,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Get.to(() =>
                    WebViewWidget(state: UrlState.privacyPolicy));
                },
              child: const Text(
                '개인정보 처리방침',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Get.to(() =>
                    WebViewWidget(state: UrlState.openSourceLicense));
              },
              child: const Text(
                '오픈소스 라이센스',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
