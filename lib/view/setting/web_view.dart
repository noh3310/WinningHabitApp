import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum UrlState { privacyPolicy, openSourceLicense }

class WebViewWidget extends StatelessWidget {
  WebViewWidget({Key? key, required this.state}) : super(key: key);
  UrlState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).pop();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        backgroundColor: Colors.white24,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: state == UrlState.privacyPolicy
              ? 'https://jerryco.notion.site/WinningHabit-f6b1653b59ac439dbed4e8dbecf2b857'
              : 'https://jerryco.notion.site/70139919073144afbb434b6b042b9799',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
