import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../booking/viewmodel/booking_controller.dart';
import '../../../routes/app_pages.dart';
import '../model/stylist_model.dart';
import 'widgets/stylist_sliver_app_bar.dart';
import 'widgets/stylist_detail_header.dart';
import 'widgets/stylist_quick_specs.dart';
import 'widgets/stylist_bottom_bar.dart';

class StylistDetailScreen extends StatelessWidget {
  final StylistModel stylist;
  final String imagePath;

  const StylistDetailScreen({
    super.key,
    required this.stylist,
    required this.imagePath,
  });

  static const _bg = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);
  static const _subtext = Colors.white70;

  void _handleBooking() {
    final bookingController = Get.put(BookingController());
    
    bookingController.resetBooking();
    bookingController.selectStylist(stylist);
    
    Get.toNamed(Routes.booking);
    
    Get.snackbar(
      'Stylist Selected',
      '${stylist.name} has been pre-selected for your booking!',
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
    final cleanRole = stylist.specialisation.replaceAll('_', ' ').toLowerCase();

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              StylistSliverAppBar(
                stylist: stylist,
                imagePath: imagePath,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    StylistDetailHeader(stylist: stylist),
                    const SizedBox(height: 24),
                    StylistQuickSpecs(stylist: stylist),
                    const SizedBox(height: 28),
                    _buildBio(cleanRole),
                    const SizedBox(height: 28),
                    _buildExpertiseSection(),
                  ]),
                ),
              ),
            ],
          ),
          StylistBottomBar(
            stylist: stylist,
            onBookingPressed: _handleBooking,
          ),
        ],
      ),
    );
  }

  Widget _buildBio(String cleanRole) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ARTIST BIOGRAPHY',
          style: TextStyle(
            color: _gold,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Meet ${stylist.name}, a distinguished master artisan specialising in high-end luxury $cleanRole treatments at Arora Luxe. With an eye for matching styling to unique personalities, ${stylist.name} combines cutting-edge techniques with premium organic products to craft a truly tailored aesthetic that leaves you feeling absolute royalty.',
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

  Widget _buildExpertiseSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _charcoalLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _gold.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.workspace_premium_rounded, color: _gold, size: 20),
              SizedBox(width: 10),
              Text(
                'Artist Specialities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExpertiseRow(Icons.bolt_rounded, 'Certified master stylist with global training credentials.'),
          const SizedBox(height: 12),
          _buildExpertiseRow(Icons.bolt_rounded, 'Known for precision aesthetics and personalized care consultations.'),
          const SizedBox(height: 12),
          _buildExpertiseRow(Icons.bolt_rounded, 'Recognised for providing top-tier luxurious guest experiences.'),
        ],
      ),
    );
  }

  Widget _buildExpertiseRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _gold, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _subtext,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
