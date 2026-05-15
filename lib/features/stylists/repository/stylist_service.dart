import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/storage_service.dart';
import '../model/stylist_model.dart';

class StylistService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<List<StylistModel>> fetchStylists({String? specialisation}) async {
    try {
      final token = await _storageService.getAccessToken();

      String endpoint = ApiEndpoints.stylists;
      if (specialisation != null) {
        endpoint += '?specialisation=$specialisation';
      }

      final response = await _apiClient.get(
        endpoint,
        token: token,
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final globalData = decodedBody['data'];

        List stylistsList;
        if (globalData is Map && globalData.containsKey('data')) {
           stylistsList = globalData['data'] as List;
        } else if (globalData is List) {
           stylistsList = globalData;
        } else {
           return [];
        }

        return stylistsList
            .map((json) => StylistModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {

      return [];
    }
  }
}
