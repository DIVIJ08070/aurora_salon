import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/booking_controller.dart';
import 'steps/customer_selection_step.dart';
import 'steps/service_selection_step.dart';
import 'steps/stylist_selection_step.dart';
import 'steps/date_time_selection_step.dart';
import 'steps/confirmation_step.dart';

class BookingWizard extends StatelessWidget {
  const BookingWizard({Key? key}) : super(key: key);

  static const _gold = Color(0xFFC5A059);
  static const _charcoal = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());

    return Scaffold(
      backgroundColor: _charcoal,
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_charcoal, _charcoalLight],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(controller),
                Obx(() => _buildStepIndicator(controller.currentStep.value)),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CustomerSelectionStep(onNext: () => controller.nextStep()),
                      ServiceSelectionStep(
                        onNext: () => controller.nextStep(),
                        onBack: () => controller.prevStep(),
                      ),
                      StylistSelectionStep(
                        onNext: () => controller.nextStep(),
                        onBack: () => controller.prevStep(),
                      ),
                      DateTimeSelectionStep(
                        onNext: () => controller.nextStep(),
                        onBack: () => controller.prevStep(),
                      ),
                      ConfirmationStep(onBack: () => controller.prevStep()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BookingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => controller.prevStep(),
          ),
          const Expanded(
            child: Text(
              'Book Appointment',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? _gold : Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: isActive ? _gold : Colors.white.withOpacity(0.2),
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: _gold.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive
                            ? _charcoal
                            : Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (index < 4)
                  Expanded(
                    child: Container(
                      height: 1,
                      color: index < currentStep
                          ? _gold
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
