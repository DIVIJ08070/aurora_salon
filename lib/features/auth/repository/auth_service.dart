import 'dart:convert';
import 'package:flutter/material.dart';
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

      return null;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {

      final response = await _apiClient.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {

        final innerData = data['data'];
        final accessToken = innerData != null ? innerData['accessToken'] : null;
        final refreshToken = innerData != null
            ? innerData['refreshToken']
            : null;

        if (accessToken != null && refreshToken != null) {

          await _storageService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );

          Userdata? user = await fetchProfile(accessToken);

          return {
            'success': true,
            'data': data,
            'user': user,
          };
        } else {

          return {
            'success': false,
            'message': 'Auth tokens missing from data field',
          };
        }
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {

      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<void> logout() async {
    try {

      final accessToken = await _storageService.getAccessToken();
      final refreshToken = await _storageService.getRefreshToken();

      if (accessToken != null && refreshToken != null) {

        await _apiClient.post(ApiEndpoints.logout, {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        });

      } else {

      }
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      await _storageService.clearTokens();

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

          return false;
        }

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
