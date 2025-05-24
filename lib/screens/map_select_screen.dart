import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapSelectScreen extends StatefulWidget {
  const MapSelectScreen({super.key});

  @override
  State<MapSelectScreen> createState() => _MapSelectScreenState();
}

class _MapSelectScreenState extends State<MapSelectScreen> {
  late KakaoMapController mapController;
  LatLng center = LatLng(37.5665, 126.9780); // 서울 시청 기본값

  @override
  void initState() {
    super.initState();
    AuthRepository.initialize(appKey: 'a7e4980f47456ce077cd8f7945702814');
  }

  void _updateCenter(LatLng latLng, int level) {
    setState(() => center = latLng);
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=${latLng.longitude}&y=${latLng.latitude}',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'KakaoAK 6596c57d90919b667fb063312e37b418'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['documents'] != null && data['documents'].isNotEmpty) {
        return data['documents'][0]['address']['address_name'];
      } else {
        return '주소 정보 없음';
      }
    } else {
      throw Exception('역지오코딩 실패: ${response.statusCode}');
    }
  }

  void _selectLocation() async {
    try {
      final address = await getAddressFromLatLng(center);
      Navigator.pop(context, {
        'lat': center.latitude,
        'lng': center.longitude,
        'address': address,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('주소 불러오기 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('거래 희망 장소 선택')),
      body: Stack(
        children: [
          KakaoMap(
            center: center,
            onMapCreated: (controller) => mapController = controller,
            onCameraIdle: _updateCenter,
          ),
          const Center(
            child: Icon(Icons.location_on, size: 40, color: Colors.red),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _selectLocation,
              child: const Text('이 위치로 선택'),
            ),
          ),
        ],
      ),
    );
  }
}
