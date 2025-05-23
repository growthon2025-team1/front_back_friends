// This is a stub implementation of WebView for web platform
import 'package:flutter/material.dart';

// NavigationDelegate 스텁 구현
class NavigationDelegate {
  final Function(String)? onPageFinished;
  
  const NavigationDelegate({this.onPageFinished});
}

// Stub implementation of WebViewController for web
class WebViewController {
  String? _htmlContent;

  WebViewController setJavaScriptMode(JavaScriptMode mode) => this;
  
  WebViewController loadHtmlString(String htmlContent) {
    _htmlContent = htmlContent;
    return this;
  }
  
  WebViewController setNavigationDelegate(NavigationDelegate delegate) {
    // 웹 환경에서는 페이지 로드 완료 콜백 직접 호출
    Future.delayed(Duration(milliseconds: 500), () {
      if (delegate.onPageFinished != null) {
        delegate.onPageFinished!('about:blank');
      }
    });
    return this;
  }
  
  Future<void> runJavaScript(String javaScript) async {
    // 웹 환경에서는 아무 작업도 수행하지 않음
    print('웹 환경에서 JavaScript 실행 무시: ${javaScript.substring(0, javaScript.length > 50 ? 50 : javaScript.length)}...');
    return;
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
