import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart' if (dart.library.html) 'package:testapp/web/web_view_stub.dart';
import '../services/post_service.dart';
import '../utils/auth_token.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final WebViewController _controller;
  List<dynamic> posts = [];
  bool isLoading = true;
  bool isShowingUserLocation = false;
  
  @override
  void initState() {
    super.initState();
    
    // 웹뷰 컨트롤러 초기화
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            // 페이지 로드 완료 후 게시글 데이터 가져오기
            fetchPosts();
          },
        ),
      )
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
  
  // 게시글 데이터 가져오기
  Future<void> fetchPosts() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final postList = await PostService.fetchPostList();
      setState(() {
        posts = postList;
        isLoading = false;
      });
      
      // 지도에 마커 추가
      addMarkersToMap();
    } catch (e) {
      print('게시글 로드 오류: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  // 지도에 마커 추가
  Future<void> addMarkersToMap() async {
    if (posts.isEmpty) return;
    
    // 웹 환경에서는 작동하지 않음
    if (kIsWeb) return;
    
    // 마커 데이터 JSON 문자열로 변환
    final markersJson = jsonEncode(posts.map((post) {
      // 위치 정보가 없는 경우 기본값 사용 (서울시청)
      double lat = 37.5665;
      double lng = 126.9780;
      
      // 게시글에 위치 정보가 있는 경우
      if (post.containsKey('latitude') && post.containsKey('longitude')) {
        lat = post['latitude'] is double ? post['latitude'] : double.tryParse(post['latitude'].toString()) ?? 37.5665;
        lng = post['longitude'] is double ? post['longitude'] : double.tryParse(post['longitude'].toString()) ?? 126.9780;
      }
      
      return {
        'id': post['id'],
        'title': post['title'] ?? '제목 없음',
        'content': post['content'] ?? '내용 없음',
        'lat': lat,
        'lng': lng,
      };
    }).toList());
    
    // JavaScript로 마커 추가
    _controller.runJavaScript('''
      try {
        const markers = $markersJson;
        addMarkersToMap(markers);
      } catch (e) {
        console.error('마커 추가 오류:', e);
      }
    ''');
  }
  
  // 사용자 위치 표시 토글
  void toggleUserLocation() {
    if (kIsWeb) return; // 웹 환경에서는 작동하지 않음
    
    setState(() {
      isShowingUserLocation = !isShowingUserLocation;
    });
    
    _controller.runJavaScript('''
      try {
        toggleUserLocation(${isShowingUserLocation ? 'true' : 'false'});
      } catch (e) {
        console.error('사용자 위치 토글 오류:', e);
      }
    ''');
  }
  
  // 지도 새로고침
  void refreshMap() {
    fetchPosts();
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
          // 지도 표시
          WebViewWidget(controller: _controller),
          
          // 로딩 인디케이터
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          
          // 지도 컨트롤 버튼들
          Positioned(
            top: 50,
            right: 20,
            child: Column(
              children: [
                // 새로고침 버튼
                FloatingActionButton(
                  heroTag: 'refresh',
                  mini: true,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.refresh, color: Colors.black87),
                  onPressed: refreshMap,
                ),
                SizedBox(height: 10),
                // 내 위치 버튼
                FloatingActionButton(
                  heroTag: 'location',
                  mini: true,
                  backgroundColor: isShowingUserLocation ? Colors.green : Colors.white,
                  child: Icon(Icons.my_location, 
                    color: isShowingUserLocation ? Colors.white : Colors.black87),
                  onPressed: toggleUserLocation,
                ),
              ],
            ),
          ),
          
          // 하단 네비게이션 바
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>모두의 냉장고 지도</title>
    <script type="text/javascript"
      src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=a7e4980f47456ce077cd8f7945702814&libraries=services,clusterer,drawing&autoload=false">
    </script>
    <style>
      html, body { margin: 0; padding: 0; height: 100%; }
      #map { width: 100%; height: 100%; }
      .info-window { padding: 10px; max-width: 200px; }
      .info-window h4 { margin: 5px 0; color: #007bff; }
      .info-window p { margin: 5px 0; font-size: 12px; }
      .info-window button { 
        background-color: #4CAF50; color: white; border: none; 
        padding: 5px 10px; border-radius: 3px; cursor: pointer; 
        margin-top: 5px; font-size: 12px;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script>
      // 전역 변수
      let map;
      let markers = [];
      let userMarker = null;
      let watchId = null;
      
      // 지도 초기화
      kakao.maps.load(function() {
        const mapContainer = document.getElementById('map');
        const mapOption = {
          center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울 시청
          level: 5
        };
        
        map = new kakao.maps.Map(mapContainer, mapOption);
        
        // 줌 컨트롤 추가
        const zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      });
      
      // 게시글 마커 추가 함수
      function addMarkersToMap(markerData) {
        // 기존 마커 삭제
        removeAllMarkers();
        
        markerData.forEach(data => {
          const position = new kakao.maps.LatLng(data.lat, data.lng);
          
          // 마커 생성
          const marker = new kakao.maps.Marker({
            position: position,
            map: map
          });
          
          // 정보창 내용
          const content = '
            <div class="info-window">
              <h4>' + data.title + '</h4>
              <p>' + (data.content.length > 50 ? data.content.substring(0, 50) + '...' : data.content) + '</p>
              <button onclick="openPostDetail(' + data.id + ')">자세히 보기</button>
            </div>
          ';
          
          // 인포윈도우 생성
          const infowindow = new kakao.maps.InfoWindow({
            content: content,
            removable: true
          });
          
          // 마커 클릭 이벤트
          kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map, marker);
          });
          
          // 마커 배열에 추가
          markers.push({ marker, infowindow });
        });
        
        // 모든 마커가 보이도록 지도 범위 조정
        if (markers.length > 0) {
          const bounds = new kakao.maps.LatLngBounds();
          markers.forEach(item => bounds.extend(item.marker.getPosition()));
          map.setBounds(bounds);
        }
      }
      
      // 마커 전체 삭제
      function removeAllMarkers() {
        markers.forEach(item => {
          item.marker.setMap(null);
          if (item.infowindow) {
            item.infowindow.close();
          }
        });
        markers = [];
      }
      
      // 게시글 상세 보기
      function openPostDetail(postId) {
        // Flutter에 메시지 보내기
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler('openPostDetail', postId);
        } else {
          console.log('게시글 상세 보기:', postId);
        }
      }
      
      // 사용자 위치 표시 토글
      function toggleUserLocation(show) {
        if (show) {
          // 사용자 위치 추적 시작
          if (navigator.geolocation) {
            watchId = navigator.geolocation.watchPosition(
              updateUserPosition,
              handleLocationError,
              { enableHighAccuracy: true, maximumAge: 10000, timeout: 10000 }
            );
          } else {
            alert('이 브라우저에서는 위치 정보를 사용할 수 없습니다.');
          }
        } else {
          // 사용자 위치 추적 중지
          if (watchId !== null) {
            navigator.geolocation.clearWatch(watchId);
            watchId = null;
          }
          
          // 사용자 마커 제거
          if (userMarker) {
            userMarker.setMap(null);
            userMarker = null;
          }
        }
      }
      
      // 사용자 위치 업데이트
      function updateUserPosition(position) {
        const lat = position.coords.latitude;
        const lng = position.coords.longitude;
        const latlng = new kakao.maps.LatLng(lat, lng);
        
        // 처음 위치를 받았을 때 지도 중심 이동
        if (!userMarker) {
          map.setCenter(latlng);
          map.setLevel(3);
        }
        
        // 사용자 마커가 없으면 생성
        if (!userMarker) {
          userMarker = new kakao.maps.Marker({
            position: latlng,
            map: map,
            title: '내 위치',
            image: new kakao.maps.MarkerImage(
              'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
              new kakao.maps.Size(24, 35)
            )
          });
        } else {
          // 기존 마커 위치 업데이트
          userMarker.setPosition(latlng);
        }
      }
      
      // 위치 오류 처리
      function handleLocationError(error) {
        let message = '';
        switch(error.code) {
          case error.PERMISSION_DENIED:
            message = '위치 정보 권한이 거부되었습니다.';
            break;
          case error.POSITION_UNAVAILABLE:
            message = '위치 정보를 사용할 수 없습니다.';
            break;
          case error.TIMEOUT:
            message = '위치 정보 요청 시간이 초과되었습니다.';
            break;
          default:
            message = '알 수 없는 오류가 발생했습니다.';
            break;
        }
        console.error('위치 오류:', message);
        alert(message);
      }
    </script>
  </body>
</html>
''';
