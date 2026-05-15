import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/booking_controller.dart';

class ConfirmationStep extends StatelessWidget {
  final VoidCallback onBack;

  const ConfirmationStep({Key? key, required this.onBack}) : super(key: key);

  static const _gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find<BookingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Review Booking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildSummaryCard(controller),
                const SizedBox(height: 24),
                _buildDetailRow('Customer', controller.selectedCustomer.value!.name),
                _buildDetailRow('Stylist', controller.selectedStylist.value!.name),
                _buildDetailRow('Date', DateFormat('EEEE, d MMMM yyyy').format(controller.selectedDate.value!)),
                _buildDetailRow('Time', controller.selectedTimeSlot.value!.startTime.substring(0, 5)),
                const Divider(color: Colors.white10, height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                ...controller.selectedServices.map((service) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(service.name, style: const TextStyle(color: Colors.white54)),
                      Text('\$${service.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                )).toList(),
                const Divider(color: Colors.white10, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${controller.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: _gold, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        _buildBottomButtons(controller),
      ],
    );
  }

  Widget _buildSummaryCard(BookingController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available, color: _gold, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appointment Summary',
                  style: TextStyle(color: _gold, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.selectedServices.length} services selected',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BookingController controller) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onBack,
              child: const Text(
                'BACK',
                style: TextStyle(color: Colors.white54, letterSpacing: 1.5),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isSubmitting.value ? null : controller.confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Text(
                      'CONFIRM BOOKING',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
            )),
          ),
        ],
      ),
    );
  }
}
