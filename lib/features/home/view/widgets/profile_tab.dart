import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/viewmodel/loginvc.dart';
import '../../../booking/viewmodel/appointment_controller.dart';

class ProfileTab extends StatelessWidget {
  final LoginVC loginController;

  const ProfileTab({super.key, required this.loginController});

  static const _bg = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;
  static const _subtext = Colors.white54;

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.put(AppointmentController());

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Obx(() {
            final user = loginController.user.value;
            final userAppointments = appointmentController.appointments;
            final activeCount = userAppointments
                .where((a) => a.status.toLowerCase() == 'scheduled')
                .length;
            final completedCount = userAppointments
                .where((a) => a.status.toLowerCase() == 'completed')
                .length;
            final loyaltyPoints = completedCount * 150;

            final cleanName = user?.name != null && user!.name.isNotEmpty
                ? user.name
                : (user?.email.split('@').first.capitalizeFirst ??
                      'Guest Member');
            final cleanRole = user?.role.toUpperCase() ?? 'MEMBER';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildAvatarHeader(cleanName, user?.email ?? '', cleanRole),
                const SizedBox(height: 32),
                _buildStatsDashboard(
                  userAppointments.length,
                  activeCount,
                  loyaltyPoints,
                ),
                const SizedBox(height: 36),
                _buildSettingsSection(user?.id.toString() ?? 'N/A', cleanRole),
                const SizedBox(height: 40),
                _buildLogoutButtons(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAvatarHeader(String name, String email, String role) {
    final isVip = role == 'USER' || role == 'MEMBER';
    final badgeLabel = isVip ? 'ARORA LUXE MEMBER' : 'ARORA $role';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _gold.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: _charcoalLight,
            child: Text(
              name.substring(0, name.length > 1 ? 2 : 1).toUpperCase(),
              style: const TextStyle(
                color: _gold,
                fontSize: 32,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(
            color: _text,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          email,
          style: const TextStyle(
            color: _subtext,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _gold.withValues(alpha: 0.35), width: 1),
          ),
          child: Text(
            badgeLabel,
            style: const TextStyle(
              color: _gold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsDashboard(int total, int active, int points) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: _charcoalLight.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(total.toString(), 'TOTAL VISITS'),
              Container(
                width: 1,
                height: 35,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _buildStatItem(active.toString(), 'SCHEDULED'),
              Container(
                width: 1,
                height: 35,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _buildStatItem(points.toString(), 'LUXE POINTS'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _gold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String id, String role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACCOUNT SETTINGS',
          style: TextStyle(
            color: _gold,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(Icons.fingerprint_rounded, 'Member ID', '#$id'),
        _buildSettingsItem(
          Icons.star_outline_rounded,
          'Membership Tier',
          'Exclusive Elite',
        ),
        _buildSettingsItem(
          Icons.notifications_none_rounded,
          'Notification Push',
          'Activated',
        ),
        _buildSettingsItem(
          Icons.support_agent_rounded,
          'Contact Luxe Concierge',
          'Ready',
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: _charcoalLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.03),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: _gold, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: loginController.normalLogout,
          icon: const Icon(Icons.logout, color: Colors.black, size: 18),
          label: const Text(
            'LOG OUT',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _gold,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: _gold.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: loginController.hardLogout,
          icon: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.redAccent,
            size: 18,
          ),
          label: const Text(
            'HARD LOG OUT (RESET)',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            side: const BorderSide(color: Colors.redAccent, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            splashFactory: InkRipple.splashFactory,
          ),
        ),
      ],
    );
  }
}
