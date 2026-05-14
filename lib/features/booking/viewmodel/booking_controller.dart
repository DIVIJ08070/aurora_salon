import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/model/service_model.dart';
import '../../stylists/model/stylist_model.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../model/booking_model.dart';
import '../repository/booking_repository.dart';
import '../model/customer_model.dart';
import '../model/appointment_model.dart';

class BookingController extends GetxController {
  final BookingRepository _repository = BookingRepository();
  
  // Selection state
  var selectedCustomer = Rxn<CustomerModel>();
  var selectedServices = <ServiceModel>[].obs;
  var selectedStylist = Rxn<StylistModel>();
  var selectedDate = Rxn<DateTime>();
  var selectedTimeSlot = Rxn<TimeSlotModel>();
  
  // Loading states
  var isLoadingCustomers = false.obs;
  var isLoadingStylists = false.obs;
  var isLoadingDates = false.obs;
  var isLoadingSlots = false.obs;
  var isLoadingStylistAppointments = false.obs;
  var isSubmitting = false.obs;
  
  // Data lists
  var customers = <CustomerModel>[].obs;
  var filteredStylists = <StylistModel>[].obs;
  var availableDates = <String>[].obs;
  var availableSlots = <TimeSlotModel>[].obs;
  var allTimeSlots = <TimeSlotModel>[].obs;
  var stylistAppointments = <AppointmentModel>[].obs;

  // Navigation state
  var currentStep = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchCustomers();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      confirmBooking();
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  Future<void> fetchCustomers() async {
    isLoadingCustomers.value = true;
    try {
      final fetched = await _repository.fetchCustomers();
      customers.assignAll(fetched);
    } finally {
      isLoadingCustomers.value = false;
    }
  }
  
  // Computed properties
  int get totalDuration => selectedServices.fold(0, (sum, item) => sum + item.durationMinutes);
  double get totalPrice => selectedServices.fold(0.0, (sum, item) => sum + item.price);
  
  // Calculate how many 30-min slots are needed
  int get slotsNeeded => (totalDuration / 30).ceil();

  // Check if a slot should be highlighted based on selection and duration
  bool isSlotInSelectedRange(int currentIndex) {
    if (selectedTimeSlot.value == null) return false;
    
    final selectedIndex = allTimeSlots.indexWhere((s) => s.startTime == selectedTimeSlot.value!.startTime);
    if (selectedIndex == -1) return false;
    
    return currentIndex >= selectedIndex && currentIndex < selectedIndex + slotsNeeded;
  }
  
  Future<void> fetchFilteredStylists() async {
    if (selectedServices.isEmpty) {
      filteredStylists.clear();
      return;
    }
    isLoadingStylists.value = true;
    try {
      final ids = selectedServices.map((s) => s.id).toList();
      debugPrint('[BookingController] Fetching stylists for service IDs: $ids');
      final stylists = await _repository.fetchFilteredStylists(ids);
      debugPrint('[BookingController] Got ${stylists.length} filtered stylists');
      filteredStylists.assignAll(stylists);
    } catch (e) {
      debugPrint('[BookingController] Error fetching stylists: $e');
    } finally {
      isLoadingStylists.value = false;
    }
  }
  
  void toggleService(ServiceModel service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
    // Clear downstream selections
    selectedStylist.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    availableDates.clear();
    availableSlots.clear();
    
    // Smart Filter: Fetch stylists that can do the new set of services
    fetchFilteredStylists();
  }

  void selectStylist(StylistModel stylist) {
    selectedStylist.value = stylist;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    availableSlots.clear();
    stylistAppointments.clear();
    fetchAvailableDates();
    fetchStylistAppointments();
  }

  Future<void> fetchStylistAppointments() async {
    if (selectedStylist.value == null) return;
    
    isLoadingStylistAppointments.value = true;
    try {
      final appointments = await _repository.fetchAppointments(
        stylistId: selectedStylist.value!.id,
      );
      debugPrint('[BookingController] Fetched ${appointments.length} appointments for stylist ${selectedStylist.value!.id}');
      stylistAppointments.assignAll(appointments);
    } catch (e) {
      debugPrint('[BookingController] Error fetching stylist appointments: $e');
    } finally {
      isLoadingStylistAppointments.value = false;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTimeSlot.value = null;
    fetchAvailableSlots();
    fetchAllSlots();
  }

  Future<void> fetchAllSlots() async {
    if (selectedStylist.value == null || selectedDate.value == null) return;
    
    try {
      final dateStr = "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
      final slots = await _repository.fetchAllTimeSlots(
        stylistId: selectedStylist.value!.id,
        date: dateStr,
      );
      allTimeSlots.assignAll(slots);
    } catch (e) {
      debugPrint('[BookingController] Error fetching all slots: $e');
    }
  }

  Future<void> fetchAvailableDates() async {
    if (selectedStylist.value == null) return;
    
    isLoadingDates.value = true;
    try {
      final now = DateTime.now();
      final dates = await _repository.fetchAvailableDates(
        stylistId: selectedStylist.value!.id,
        durationMinutes: totalDuration,
        month: selectedDate.value?.month ?? now.month,
        year: selectedDate.value?.year ?? now.year,
      );
      availableDates.assignAll(dates);
    } finally {
      isLoadingDates.value = false;
    }
  }

  Future<void> fetchAvailableSlots() async {
    if (selectedStylist.value == null || selectedDate.value == null) return;
    
    isLoadingSlots.value = true;
    try {
      final dateStr = "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
      final slots = await _repository.fetchAvailableSlots(
        stylistId: selectedStylist.value!.id,
        date: dateStr,
        durationMinutes: totalDuration,
      );
      availableSlots.assignAll(slots);
    } finally {
      isLoadingSlots.value = false;
    }
  }

  Future<void> confirmBooking() async {
    if (selectedCustomer.value == null || selectedStylist.value == null || selectedDate.value == null || selectedTimeSlot.value == null || selectedServices.isEmpty) {
      Get.snackbar('Error', 'Please complete all steps');
      return;
    }

    isSubmitting.value = true;
    try {
      final dateStr = "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
      
      final request = BookingRequest(
        customerId: selectedCustomer.value!.id,
        stylistId: selectedStylist.value!.id,
        appointmentDate: dateStr,
        startTime: selectedTimeSlot.value!.startTime,
        serviceIds: selectedServices.map((e) => e.id).toList(),
      );

      final success = await _repository.createBooking(request);
      if (success) {
        Get.back(); // Go back to home or summary
        Get.snackbar('Success', 'Booking confirmed successfully!');
        resetBooking();
      } else {
        Get.snackbar('Error', 'Failed to create booking');
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetBooking() {
    selectedServices.clear();
    selectedStylist.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    availableDates.clear();
    availableSlots.clear();
  }
}
