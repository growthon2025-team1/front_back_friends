import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? posts;
  const MapScreen({Key? key, this.posts}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late KakaoMapController mapController;
  LatLng? currentLatLng;

  @override
  void initState() {
    super.initState();
    AuthRepository.initialize(appKey: 'a7e4980f47456ce077cd8f7945702814');
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final position = await _determinePosition();
      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('위치 가져오기 실패: $e');
      // 기본 좌표 (서울시청)
      setState(() {
        currentLatLng = LatLng(37.5665, 126.9780);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts =
        widget.posts ??
        [
          {'title': '귤 나눔해요', 'lat': 37.5665, 'lng': 126.9780},
          {'title': '도서 교환합니다', 'lat': 37.5672, 'lng': 126.9791},
          {'title': '텀블러 나눔', 'lat': 37.5651, 'lng': 126.9769},
        ];

    final markers =
        posts.map((post) {
          return Marker(
            markerId: post['title'],
            latLng: LatLng(post['lat'], post['lng']),
            infoWindowContent: post['title'],
            width: 40,
            height: 40,
          );
        }).toList();

    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    double scaleW(double value) => value * (w / 375);
    double scaleH(double value) => value * (h / 812);

    return Scaffold(
      body: Stack(
        children: [
          if (currentLatLng != null)
            KakaoMap(
              onMapCreated: (controller) => mapController = controller,
              center: currentLatLng!,
              markers: markers,
            )
          else
            const Center(child: CircularProgressIndicator()),
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
          Image.asset(imagePath, width: scaleW(24), height: scaleH(24)),
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

// 위치 권한 및 현재 위치 가져오기
Future<Position> _determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('위치 서비스가 꺼져 있습니다.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('위치 권한이 거부되었습니다.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('위치 권한이 영구적으로 거부되었습니다.');
  }

  return await Geolocator.getCurrentPosition();
}
