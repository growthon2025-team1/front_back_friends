import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart' if (dart.library.html) 'package:testapp/web/web_view_stub.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    
    // 웹뷰 컨트롤러 초기화
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_kakaoMapHtml);
    
    // 웹 플랫폼이 아닐 때만 URL 디버깅 (웹 플랫폼에서는 currentUrl이 작동하지 않음)
    if (!kIsWeb) {
      Future.delayed(Duration(seconds: 1), () {
        _controller.currentUrl().then((url) {
          print("웹뷰 현재 URL: $url");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    double scaleW(double value) => value * (w / 375);
    double scaleH(double value) => value * (h / 812);

    return Scaffold(
      body: Stack(
        children: [
          
          WebViewWidget(controller: _controller),
          
          Positioned(
            left: 0,
            bottom: 0,
            width: w,
            height: scaleH(83),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: scaleW(36)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    imagePath: 'assets/images/home.png',
                    label: '홈',
                    onTap: () => Navigator.pushNamed(context, '/home'),
                  ),
                  _NavItem(
                    imagePath: 'assets/images/mapClicked.png',
                    label: '지도',
                    onTap: () => Navigator.pushNamed(context, '/map'),
                  ),
                  _NavItem(
                    imagePath: 'assets/images/chat.png',
                    label: '채팅',
                    onTap: () => Navigator.pushNamed(context, '/chat'),
                  ),
                  _NavItem(
                    imagePath: 'assets/images/my.png',
                    label: '마이',
                    onTap: () => Navigator.pushNamed(context, '/mypage'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    double scaleW(double value) => value * (w / 375);
    double scaleH(double value) => value * (h / 812);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: scaleW(24),
            height: scaleH(24),
          ),
          SizedBox(height: scaleH(4)),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w300,
              fontSize: 9,
              color: Color(0xFFB4B4B4),
              height: 1.22,
            ),
          ),
        ],
      ),
    );
  }
}

const String _kakaoMapHtml = ''' 
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Kakao Map</title>
    <script type="text/javascript"
      src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=a7e4980f47456ce077cd8f7945702814&autoload=false">
    </script>
    <style>
      html, body { margin: 0; padding: 0; height: 100%; }
      #map { width: 100%; height: 100%; }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script>
      kakao.maps.load(function() {
        var mapContainer = document.getElementById('map'); 
        var mapOption = {
          center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울
          level: 3
        };  
        var map = new kakao.maps.Map(mapContainer, mapOption); 
      });
    </script>
  </body>
</html>
''';
