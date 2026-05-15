import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/booking_controller.dart';

class StylistSelectionStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StylistSelectionStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  static const _gold = Color(0xFFC5A059);
  static const _card = Color(0xFF1C1C1C);

  String _getStylistFallback(int index) {
    final images = [
      'assets/stylist1.png',
      'assets/stylist2.png',
      'assets/stylist3.png',
      'assets/stylist4.png',
      'assets/stylist5.png',
      'assets/salon_interior.png',
    ];
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.find<BookingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Select Artist',
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
            'Who will create your new look?',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Obx(() {
            if (bookingController.isLoadingStylists.value) {
              return const Center(child: CircularProgressIndicator(color: _gold));
            }

            if (bookingController.filteredStylists.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off_outlined, size: 64, color: Colors.white.withValues(alpha: 0.05)),
                    const SizedBox(height: 16),
                    const Text(
                      'No stylists available',
                      style: TextStyle(color: Colors.white24),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: bookingController.filteredStylists.length,
              itemBuilder: (context, index) {
                final stylist = bookingController.filteredStylists[index];

                return Obx(() {
                  final isSelected = bookingController.selectedStylist.value?.id == stylist.id;
                  return GestureDetector(
                    onTap: () => bookingController.selectStylist(stylist),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? _gold : Colors.white.withValues(alpha: 0.05),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: _gold.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
                        ] : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [

                            Positioned.fill(
                              child: stylist.imageUrl != null && stylist.imageUrl!.startsWith('http')
                                ? Image.network(stylist.imageUrl!, fit: BoxFit.cover)
                                : Image.asset(_getStylistFallback(index), fit: BoxFit.cover),
                            ),

                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.9),
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
                                    stylist.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    stylist.specialisation,
                                    style: TextStyle(
                                      color: _gold.withValues(alpha: 0.8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                  child: const Icon(Icons.check, color: Colors.black, size: 14),
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
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildBottomBar() {
    final controller = Get.find<BookingController>();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onBack,
              child: const Text(
                'BACK',
                style: TextStyle(color: Colors.white38, letterSpacing: 1.5, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() => ElevatedButton(
              onPressed: controller.selectedStylist.value == null ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
