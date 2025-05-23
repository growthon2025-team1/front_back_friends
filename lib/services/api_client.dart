import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiClient {
  static const _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final finalHeaders = {..._defaultHeaders, if (headers != null) ...headers};

    try {
      final response = await http.post(uri, headers: finalHeaders, body: jsonEncode(body));
      _logResponse(response);
      return response;
    } catch (e) {
      dev.log('POST 오류: $e');
      rethrow;
    }
  }

  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final finalHeaders = {..._defaultHeaders, if (headers != null) ...headers};

    try {
      final response = await http.get(uri, headers: finalHeaders);
      _logResponse(response);
      return response;
    } catch (e) {
      dev.log('GET 오류: $e');
      rethrow;
    }
  }

  static void _logResponse(http.Response response) {
    dev.log('응답 코드: ${response.statusCode}');
    dev.log('응답 본문: ${response.body}');
  }
}