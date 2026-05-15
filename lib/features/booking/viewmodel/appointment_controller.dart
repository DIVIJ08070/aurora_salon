import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../model/appointment_model.dart';
import '../repository/booking_repository.dart';

class AppointmentController extends GetxController {
  final BookingRepository _repository = BookingRepository();

  var appointments = <AppointmentModel>[].obs;
  var isLoading = false.obs;

  var searchText = ''.obs;
  var selectedStatus = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();

    debounce(
      searchText,
      (_) => fetchAppointments(),
      time: const Duration(milliseconds: 500),
    );
    ever(selectedStatus, (_) => fetchAppointments());

    final LoginVC loginVC = Get.find<LoginVC>();
    ever(loginVC.user, (_) {

      fetchAppointments();
    });
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    try {

      final fetched = await _repository.fetchAppointments(
        search: searchText.value,
        status: selectedStatus.value,
      );

      appointments.assignAll(fetched);
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
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
        return const Color(0xFFC5A059);
      default:
        return Colors.blue;
    }
  }
}
