import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/booking_controller.dart';
import '../../model/customer_model.dart';

class CustomerSelectionStep extends StatelessWidget {
  final VoidCallback onNext;

  const CustomerSelectionStep({Key? key, required this.onNext})
    : super(key: key);

  static const _gold = Color(0xFFC5A059);
  static const _card = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find<BookingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Select Customer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Pick a client for this booking',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),

        // Search Bar (Optional UI Polish)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search customers...',
              hintStyle: const TextStyle(color: Colors.white24),
              prefixIcon: const Icon(Icons.search, color: _gold),
              filled: true,
              fillColor: _card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Obx(() {
            if (controller.isLoadingCustomers.value) {
              return const Center(
                child: CircularProgressIndicator(color: _gold),
              );
            }

            if (controller.customers.isEmpty) {
              return const Center(
                child: Text(
                  'No customers found',
                  style: TextStyle(color: Colors.white38),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: controller.customers.length,
              itemBuilder: (context, index) {
                final customer = controller.customers[index];

                return Obx(() {
                  final isSelected =
                      controller.selectedCustomer.value?.id == customer.id;
                  return GestureDetector(
                    onTap: () => controller.selectedCustomer.value = customer,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? _gold.withOpacity(0.1) : _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? _gold
                              : Colors.white.withOpacity(0.05),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: _gold.withOpacity(0.2),
                            child: Text(
                              customer.name.isNotEmpty
                                  ? customer.name.substring(0, 1).toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: _gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  customer.email ?? '',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: _gold),
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
        _buildBottomBar(controller),
      ],
    );
  }

  Widget _buildBottomBar(BookingController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.selectedCustomer.value == null ? null : onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: _gold,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.white.withOpacity(0.1),
          ),
          child: const Text(
            'CONTINUE',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
