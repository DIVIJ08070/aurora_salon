import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/storage_service.dart';
import '../model/userdata.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<Userdata?> fetchProfile(String token) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile, token: token);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final innerData = data['data'] ?? data;
        return Userdata.fromJson(innerData);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      debugPrint('--- Login API Call Started ---');
      final response = await _apiClient.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      debugPrint('Login Status Code: ${response.statusCode}');
      final data = jsonDecode(response.body);
      debugPrint('Login Response Data: $data');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Tokens are nested inside 'data' field because of SuccessInterceptor
        final innerData = data['data'];
        final accessToken = innerData != null ? innerData['accessToken'] : null;
        final refreshToken = innerData != null
            ? innerData['refreshToken']
            : null;

        if (accessToken != null && refreshToken != null) {
          debugPrint('Tokens found in nested data, saving to storage...');
          await _storageService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
          debugPrint('Tokens saved successfully');
          
          // Fetch full profile since login only returns tokens
          Userdata? user = await fetchProfile(accessToken);
          
          return {
            'success': true,
            'data': data,
            'user': user,
          };
        } else {
          debugPrint(
            'CRITICAL: Login succeeded but tokens are missing from nested data field!',
          );
          debugPrint('Full response structure: $data');
          return {
            'success': false,
            'message': 'Auth tokens missing from data field',
          };
        }
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      debugPrint('Login API Error: $e');
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<void> logout() async {
    try {
      debugPrint('--- Logout Process Started ---');
      final accessToken = await _storageService.getAccessToken();
      final refreshToken = await _storageService.getRefreshToken();

      debugPrint(
        'Retrieved Access Token from storage: ${accessToken != null ? "FOUND" : "MISSING"}',
      );
      debugPrint(
        'Retrieved Refresh Token from storage: ${refreshToken != null ? "FOUND" : "MISSING"}',
      );

      if (accessToken != null && refreshToken != null) {
        debugPrint(
          'Calling Logout API at: ${_apiClient.baseUrl}${ApiEndpoints.logout}',
        );
        final response = await _apiClient.post(ApiEndpoints.logout, {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        });
        debugPrint('Logout API Response Status: ${response.statusCode}');
        debugPrint('Logout API Response Body: ${response.body}');
      } else {
        debugPrint(
          'WARNING: Skipping API call because tokens are missing from storage',
        );
      }
    } catch (e) {
      debugPrint('Logout API Error: $e');
    } finally {
      await _storageService.clearTokens();
      debugPrint('Local tokens cleared from storage');
      debugPrint('--- Logout Process Finished ---');
    }
  }

  Future<bool> refreshTokens() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiClient.post(ApiEndpoints.refresh, {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final innerData = data['data'];
        final newAccessToken = innerData != null
            ? innerData['accessToken']
            : null;

        if (newAccessToken == null) {
          debugPrint('Refresh failed: New access token missing from response');
          return false;
        }

        // Note: Backend might not return a new refresh token on refresh
        final newRefreshToken = innerData['refreshToken'] ?? refreshToken;

        await _storageService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
