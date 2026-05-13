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
    debounce(searchText, (_) => fetchAppointments(), time: const Duration(milliseconds: 500));
    ever(selectedStatus, (_) => fetchAppointments());
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    try {
      // Get current user ID from LoginVC
      final LoginVC loginVC = Get.find<LoginVC>();
      final userId = loginVC.user.value?.id;
      
      if (userId == null) {
        debugPrint('[AppointmentController] No user logged in, clearing appointments.');
        appointments.clear();
        return;
      }

      final fetched = await _repository.fetchAppointments(
        customerId: userId, // Pass the logged in user's ID
        search: searchText.value,
        status: selectedStatus.value,
      );
      
      debugPrint('[AppointmentController] Fetched ${fetched.length} appointments for user $userId');
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
