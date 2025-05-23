// This is a stub implementation of WebView for web platform
import 'package:flutter/material.dart';

// Stub implementation of WebViewController for web
class WebViewController {
  String? _htmlContent;

  WebViewController setJavaScriptMode(JavaScriptMode mode) => this;
  
  WebViewController loadHtmlString(String htmlContent) {
    _htmlContent = htmlContent;
    return this;
  }
  
  Future<String?> currentUrl() async => null;
}

// Stub implementation of JavaScriptMode for web
enum JavaScriptMode {
  unrestricted,
  disabled,
}

// Stub implementation of WebViewWidget for web
class WebViewWidget extends StatelessWidget {
  final WebViewController controller;
  
  const WebViewWidget({Key? key, required this.controller}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // On web, we'll display a placeholder instead of actual WebView
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '지도 보기',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            '웹 버전에서는 지도 기능이 제한적으로 작동합니다.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('내 위치 확인하기'),
          ),
        ],
      ),
    );
  }
}
