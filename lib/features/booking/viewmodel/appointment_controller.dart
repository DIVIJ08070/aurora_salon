import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../model/appointment_model.dart';
import '../repository/booking_repository.dart';

class AppointmentController extends GetxController {
  final BookingRepository _repository = BookingRepository();

  var appointments = <AppointmentModel>[].obs;
  var isLoading = false.obs;

  // Search and Filter state
  var searchText = ''.obs;
  var selectedStatus = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();

    // Auto-fetch when search or status changes (with debounce for search)
    debounce(
      searchText,
      (_) => fetchAppointments(),
      time: const Duration(milliseconds: 500),
    );
    ever(selectedStatus, (_) => fetchAppointments());

    // IMPORTANT: This re-fetches appointments as soon as the login is confirmed
    // or the profile is restored from storage.
    final LoginVC loginVC = Get.find<LoginVC>();
    ever(loginVC.user, (_) {
      debugPrint('[AppointmentController] User profile loaded, re-fetching...');
      fetchAppointments();
    });
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    try {
      debugPrint('[AppointmentController] Fetching all appointments (no filter)...');

      final fetched = await _repository.fetchAppointments(
        search: searchText.value,
        status: selectedStatus.value,
      );
      
      debugPrint('[AppointmentController] Successfully fetched ${fetched.length} appointments');
      appointments.assignAll(fetched);
    } catch (e) {
      debugPrint('[AppointmentController] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'scheduled':
        return const Color(0xFFC5A059); // Gold
      default:
        return Colors.blue;
    }
  }
}
