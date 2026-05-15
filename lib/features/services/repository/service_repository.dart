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

      String endpoint = ApiEndpoints.services;
      if (category != null) {
        endpoint += '?category=$category';
      }

      final response = await _apiClient.get(
        endpoint,
        token: token,
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final globalData = decodedBody['data'];

        List servicesList;
        if (globalData is Map && globalData.containsKey('data')) {
           servicesList = globalData['data'] as List;
        } else if (globalData is List) {
           servicesList = globalData;
        } else {

           return [];
        }

        return servicesList
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Server returned status code: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {

      rethrow;
    }
  }
}
