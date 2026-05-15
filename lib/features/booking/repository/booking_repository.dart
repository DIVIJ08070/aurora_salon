import 'dart:convert';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/storage_service.dart';
import '../model/booking_model.dart';
import '../model/customer_model.dart';
import '../../stylists/model/stylist_model.dart';
import '../model/appointment_model.dart';

class BookingRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<List<CustomerModel>> fetchCustomers() async {
    try {
      final token = await _storageService.getAccessToken();
      final response = await _apiClient.get(ApiEndpoints.customers, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> customers = data is List ? data : (data['data'] ?? []);
        return customers.map((e) => CustomerModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }

  Future<List<StylistModel>> fetchFilteredStylists(List<int> serviceIds) async {
    try {
      final token = await _storageService.getAccessToken();

      String query = serviceIds.map((id) => 'serviceIds=$id').join('&');
      final url = '${ApiEndpoints.stylists}?$query';

      final response = await _apiClient.get(url, token: token);

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final globalData = decodedBody['data'];

        List list;
        if (globalData is Map && globalData.containsKey('data')) {
           list = globalData['data'] as List;
        } else if (globalData is List) {
           list = globalData;
        } else {
           list = decodedBody is List ? decodedBody : [];
        }

        return list.map((e) => StylistModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }

  Future<List<StylistModel>> fetchAllStylists() async {
    try {
      final token = await _storageService.getAccessToken();
      final response = await _apiClient.get(ApiEndpoints.stylists, token: token);

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final globalData = decodedBody['data'];

        List list;
        if (globalData is Map && globalData.containsKey('data')) {
          list = globalData['data'] as List;
        } else if (globalData is List) {
          list = globalData;
        } else {
          list = decodedBody is List ? decodedBody : [];
        }
        return list.map((e) => StylistModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }

  Future<List<String>> fetchAvailableDates({
    required int stylistId,
    required int durationMinutes,
    required int month,
    required int year,
  }) async {
    try {
      final token = await _storageService.getAccessToken();
      final endpoint = '${ApiEndpoints.availableDates}?stylistId=$stylistId&durationMinutes=$durationMinutes&month=$month&year=$year';

      final response = await _apiClient.get(endpoint, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> dates = data['data'] ?? [];
        return dates.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }

  Future<List<TimeSlotModel>> fetchAvailableSlots({
    required int stylistId,
    required String date,
    required int durationMinutes,
  }) async {
    try {
      final token = await _storageService.getAccessToken();
      final endpoint = '${ApiEndpoints.availableSlots}?stylistId=$stylistId&date=$date&durationMinutes=$durationMinutes';

      final response = await _apiClient.get(endpoint, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> slots = data['data'] ?? [];
        return slots.map((e) => TimeSlotModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }

  Future<List<TimeSlotModel>> fetchAllTimeSlots({
    required int stylistId,
    required String date,
  }) async {
    try {
      final token = await _storageService.getAccessToken();
      final endpoint = '/time-slots?stylistId=$stylistId&date=$date&limit=100';

      final response = await _apiClient.get(endpoint, token: token);

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final dynamic globalData = decodedBody['data'];

        List list;
        if (globalData is Map && globalData.containsKey('data')) {

          list = globalData['data'] as List;
        } else if (globalData is List) {

          list = globalData;
        } else {
          list = [];
        }

        return list.map((e) => TimeSlotModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }

  Future<bool> createBooking(BookingRequest request) async {
    try {
      final token = await _storageService.getAccessToken();
      final response = await _apiClient.post(
        ApiEndpoints.appointments,
        request.toJson(),
        token: token,
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {

      return false;
    }
  }

  Future<List<AppointmentModel>> fetchAppointments({
    int? customerId,
    int? stylistId,
    String? search,
    String? status,
  }) async {
    try {
      final token = await _storageService.getAccessToken();

      Map<String, String> queryParams = {};

      if (customerId != null) queryParams['customerId'] = customerId.toString();
      if (stylistId != null) queryParams['stylistId'] = stylistId.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty && status != 'All') queryParams['status'] = status.toLowerCase();

      String queryString = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      final url = queryString.isNotEmpty ? '${ApiEndpoints.appointments}?$queryString' : ApiEndpoints.appointments;

      final response = await _apiClient.get(url, token: token);

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        final dynamic globalData = decodedBody['data'];

        List list;
        if (globalData is Map && globalData.containsKey('data')) {
           list = globalData['data'] as List;
        } else if (globalData is List) {
           list = globalData;
        } else {
           list = decodedBody is List ? decodedBody : (decodedBody['data'] ?? []);
        }

        return list.map((e) => AppointmentModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {

      return [];
    }
  }
}
