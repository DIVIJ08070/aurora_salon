import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/booking_controller.dart';

class DateTimeSelectionStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const DateTimeSelectionStep({
    Key? key,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  static const _gold = Color(0xFFC5A059);
  static const _card = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find<BookingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _gold.withOpacity(0.2)),
                ),
                child: Obx(() => Text(
                  '${controller.totalDuration} MINS',
                  style: const TextStyle(color: _gold, fontSize: 10, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 14,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              return _buildDateItem(date, controller);
            },
          ),
        ),

        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'SELECT START TIME',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Obx(() {
            if (controller.isLoadingSlots.value) {
              return const Center(child: CircularProgressIndicator(color: _gold));
            }

            if (controller.selectedDate.value == null) {
              return const Center(
                child: Text(
                  'Pick a date to view artist availability',
                  style: TextStyle(color: Colors.white24),
                ),
              );
            }

            if (controller.availableSlots.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.white.withOpacity(0.05)),
                    const SizedBox(height: 16),
                    const Text('No slots available', style: TextStyle(color: Colors.white24)),
                  ],
                ),
              );
            }

            if (controller.allTimeSlots.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.white.withOpacity(0.05)),
                    const SizedBox(height: 16),
                    const Text('No slots generated for this day', style: TextStyle(color: Colors.white24)),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.allTimeSlots.length,
              itemBuilder: (context, index) {
                final slot = controller.allTimeSlots[index];
                final isBooked = slot.status == 'booked';
                final isBookable = controller.availableSlots.any((s) => s.startTime == slot.startTime);

                return Obx(() {
                  final isSelected = controller.isSlotInSelectedRange(index);
                  final isStart = controller.selectedTimeSlot.value?.startTime == slot.startTime;

                  Color bgColor = _card;
                  Color textColor = Colors.white;
                  Color borderColor = Colors.white.withOpacity(0.05);

                  if (isBooked) {
                    bgColor = Colors.green.withOpacity(0.2);
                    textColor = Colors.greenAccent;
                    borderColor = Colors.green.withOpacity(0.3);
                  } else if (isSelected) {
                    bgColor = _gold;
                    textColor = Colors.black;
                    borderColor = _gold;
                  } else if (!isBookable) {
                    bgColor = _card.withOpacity(0.5);
                    textColor = Colors.white24;
                  }

                  return GestureDetector(
                    onTap: (isBooked || !isBookable) ? null : () => controller.selectedTimeSlot.value = slot,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: _gold.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          )
                        ] : [],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot.startTime.substring(0, 5),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: (isSelected || isBooked) ? FontWeight.w900 : FontWeight.w500,
                                decoration: isBooked ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            if (isBooked)
                              const Text(
                                'BOOKED',
                                style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            if (isStart && controller.slotsNeeded > 1)
                              Text(
                                'START',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
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

  Widget _buildDateItem(DateTime date, BookingController controller) {
    return Obx(() {

      final selected = controller.selectedDate.value;
      final isSelected = selected != null &&
          selected.year == date.year &&
          selected.month == date.month &&
          selected.day == date.day;

      return GestureDetector(
        onTap: () => controller.selectDate(date),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 70,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? _gold : _card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? _gold : Colors.white.withOpacity(0.08),
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: _gold.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('MMM').format(date).toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.black.withOpacity(0.7) : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date.day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('EEE').format(date).toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.black.withOpacity(0.7) : _gold.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomBar() {
    final controller = Get.find<BookingController>();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onBack,
              child: const Text(
                'BACK',
                style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() => ElevatedButton(
              onPressed: controller.selectedTimeSlot.value == null ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                disabledBackgroundColor: Colors.white.withOpacity(0.05),
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
