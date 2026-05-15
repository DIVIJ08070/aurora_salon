import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/viewmodel/service_controller.dart';
import '../../viewmodel/booking_controller.dart';

class ServiceSelectionStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ServiceSelectionStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  static const _gold = Color(0xFFC5A059);
  static const _card = Color(0xFF1C1C1C);

  String _getServiceImage(int index) {
    final images = [
      'assets/cat_haircut.png',
      'assets/cat_color.png',
      'assets/cat_nails.png',
      'assets/cat_makeup.png',
      'assets/cat_skin.png',
      'assets/cat_spa.png',
      'assets/salon_interior.png',
      'assets/banner.png',
    ];
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = Get.find<ServiceController>();
    final BookingController bookingController = Get.find<BookingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Choose Services',
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
            'Select one or more treatments',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Obx(() {
            if (serviceController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: _gold),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: serviceController.availableServices.length,
              itemBuilder: (context, index) {
                final service = serviceController.availableServices[index];

                return Obx(() {
                  final isSelected = bookingController.selectedServices
                      .contains(service);
                  return GestureDetector(
                    onTap: () => bookingController.toggleService(service),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? _gold
                              : Colors.white.withValues(alpha: 0.05),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: _gold.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [

                            Positioned.fill(
                              child: Image.asset(
                                _getServiceImage(index),
                                fit: BoxFit.cover,
                              ),
                            ),

                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${service.durationMinutes}m',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        '\$${service.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: _gold,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: _gold,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
        _buildBottomBar(bookingController),
      ],
    );
  }

  Widget _buildBottomBar(BookingController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        '${controller.selectedServices.length} Selected',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        '\$${controller.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: _gold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.selectedServices.isEmpty
                      ? null
                      : onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onBack,
            child: const Text(
              'BACK',
              style: TextStyle(
                color: Colors.white38,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
