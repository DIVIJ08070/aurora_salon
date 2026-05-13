import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../viewmodel/appointment_controller.dart';
import '../model/appointment_model.dart';

class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({Key? key}) : super(key: key);

  static const _bg = Color(0xFF0D0D0D);
  static const _card = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              'My Appointments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: TextField(
                onChanged: (value) => controller.searchText.value = value,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by artist or ID...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: _gold, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: ['All', 'Scheduled', 'Completed', 'Cancelled'].map((status) {
                return Obx(() {
                  final isSelected = controller.selectedStatus.value == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => controller.selectedStatus.value = status,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? _gold : _card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _gold : Colors.white.withOpacity(0.05),
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(color: _gold.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                          ] : null,
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white.withOpacity(0.6),
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: _gold));
              }

              if (controller.appointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 64, color: Colors.white.withOpacity(0.05)),
                      const SizedBox(height: 16),
                      Text(
                        'No appointments found',
                        style: TextStyle(color: Colors.white.withOpacity(0.2)),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchAppointments,
                color: _gold,
                backgroundColor: _card,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Extra bottom padding for FAB
                  itemCount: controller.appointments.length,
                  itemBuilder: (context, index) {
                    return _buildAppointmentCard(controller.appointments[index], controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment, AppointmentController controller) {
    final statusColor = controller.getStatusColor(appointment.status);
    
    // Format the date string safely
    String formattedDate = appointment.date;
    try {
      DateTime dt = DateTime.parse(appointment.date);
      formattedDate = DateFormat('MMM dd, yyyy').format(dt);
    } catch (e) {
      // If parsing fails, just show the raw string (or parts of it)
      if (appointment.date.length > 10) {
        formattedDate = appointment.date.substring(0, 10);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_card, _card.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: ID and Status
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment.appointmentNumber,
                  style: TextStyle(
                    color: _gold.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3), width: 0.5),
                  ),
                  child: Text(
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Artist Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _gold.withOpacity(0.1),
                        border: Border.all(color: _gold.withOpacity(0.2), width: 1),
                      ),
                      child: const Icon(Icons.person_rounded, color: _gold, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.stylistName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Customer: ${appointment.customerName}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "TOTAL",
                          style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$${appointment.totalAmount.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: _gold,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Custom dotted-style divider
                Row(
                  children: List.generate(20, (index) => Expanded(
                    child: Container(
                      color: index % 2 == 0 ? Colors.transparent : Colors.white.withOpacity(0.05),
                      height: 1,
                    ),
                  )),
                ),
                const SizedBox(height: 16),
                // Footer: Date and Time with dynamic layout to prevent overflow
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildInfoBox(Icons.calendar_today_rounded, formattedDate),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildInfoBox(Icons.access_time_rounded, "${appointment.startTime} - ${appointment.endTime}"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _gold, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70, 
                fontSize: 12, 
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
