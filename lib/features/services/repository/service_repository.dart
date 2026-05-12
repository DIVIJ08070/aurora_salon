import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/storage_service.dart';
import '../model/service_model.dart';

class ServiceRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<List<ServiceModel>> fetchServices({String? category}) async {
    try {
      final token = await _storageService.getAccessToken();
      
      // Construct endpoint with query parameter if category exists
      String endpoint = ApiEndpoints.services;
      if (category != null) {
        endpoint += '?category=$category';
      }

      final response = await _apiClient.get(
        endpoint,
        token: token,
      );

      debugPrint('FetchServices Status: ${response.statusCode}');
      debugPrint('FetchServices Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final globalData = decodedBody['data'];
        
        // Sometimes the backend might return just a flat array in `data`
        // So we should check the structure:
        List servicesList;
        if (globalData is Map && globalData.containsKey('data')) {
           servicesList = globalData['data'] as List;
        } else if (globalData is List) {
           servicesList = globalData;
        } else {
           debugPrint('Unexpected data format: $globalData');
           return [];
        }

        return servicesList
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Server returned status code: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      debugPrint('Unexpected error fetching services: $e');
      rethrow;
    }
  }
}
