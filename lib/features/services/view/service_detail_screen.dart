import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../booking/viewmodel/booking_controller.dart';
import '../../../routes/app_pages.dart';
import '../model/service_model.dart';
import 'widgets/service_detail_header.dart';
import 'widgets/service_quick_specs.dart';
import 'widgets/luxury_experience_section.dart';
import 'widgets/bottom_booking_bar.dart';
import 'widgets/service_sliver_app_bar.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;
  final String imagePath;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    required this.imagePath,
  });

  static const _bg = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);
  static const _subtext = Colors.white70;

  void _handleBooking() {
    final bookingController = Get.put(BookingController());
    
    bookingController.resetBooking();
    bookingController.toggleService(service);
    
    Get.toNamed(Routes.booking);
    
    Get.snackbar(
      'Service Selected',
      '${service.name} has been pre-selected for your booking!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _charcoalLight.withValues(alpha: 0.95),
      colorText: _gold,
      borderColor: _gold.withValues(alpha: 0.3),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(Icons.check_circle_outline_rounded, color: _gold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              ServiceSliverAppBar(
                service: service,
                imagePath: imagePath,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ServiceDetailHeader(service: service),
                    const SizedBox(height: 24),
                    ServiceQuickSpecs(service: service),
                    const SizedBox(height: 28),
                    _buildDescription(),
                    const SizedBox(height: 28),
                    const LuxuryExperienceSection(),
                  ]),
                ),
              ),
            ],
          ),
          BottomBookingBar(
            service: service,
            onBookingPressed: _handleBooking,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SERVICE DETAILS',
          style: TextStyle(
            color: _gold,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          service.description.isNotEmpty
              ? service.description
              : 'Indulge in our exquisite ${service.name.toLowerCase()} treatment curated by master therapists at Arora Luxe. Designed specifically to refresh and elevate your luxury standards, this service brings together state-of-the-art styling with organic, premium products to ensure your aesthetic and comfort are unparalleled.',
          style: const TextStyle(
            color: _subtext,
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
