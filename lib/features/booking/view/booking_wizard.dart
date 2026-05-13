import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/booking_controller.dart';
import 'steps/customer_selection_step.dart';
import 'steps/service_selection_step.dart';
import 'steps/stylist_selection_step.dart';
import 'steps/date_time_selection_step.dart';
import 'steps/confirmation_step.dart';

class BookingWizard extends StatefulWidget {
  const BookingWizard({Key? key}) : super(key: key);

  @override
  State<BookingWizard> createState() => _BookingWizardState();
}

class _BookingWizardState extends State<BookingWizard> {
  final BookingController controller = Get.put(BookingController());
  final PageController _pageController = PageController();
  int _currentStep = 0;

  static const _gold = Color(0xFFC5A059);
  static const _charcoal = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      controller.confirmBooking();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _charcoal,
      body: Stack(
        children: [
          // Background Gradient
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
                _buildHeader(),
                _buildStepIndicator(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CustomerSelectionStep(onNext: _nextStep),
                      ServiceSelectionStep(
                        onNext: _nextStep,
                        onBack: _prevStep,
                      ),
                      StylistSelectionStep(
                        onNext: _nextStep,
                        onBack: _prevStep,
                      ),
                      DateTimeSelectionStep(
                        onNext: _nextStep,
                        onBack: _prevStep,
                      ),
                      ConfirmationStep(onBack: _prevStep),
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

  Widget _buildHeader() {
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
            onPressed: _prevStep,
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
          const SizedBox(width: 48), // Spacer for balance
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
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
                      color: index < _currentStep
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
