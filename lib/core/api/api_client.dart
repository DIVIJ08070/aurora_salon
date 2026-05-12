import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web/Desktop
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/v1';
    } else {
      return 'http://localhost:3000/v1';
    }
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
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {if (token != null) 'Authorization': 'Bearer $token'};

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
