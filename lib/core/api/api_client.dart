import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {

  String get baseUrl {
    // if (Platform.isAndroid) {
    //   return 'http://10.0.2.2:3000/v1';
    // }
    // return 'http://localhost:3000/v1';
    // For real physical devices on the same Wi-Fi, use:
    return 'http://192.168.29.186:3000/v1';
    // For deployed production/staging backend:
    // return 'https://surat-salon.onrender.com/v1';
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token'
    };

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
