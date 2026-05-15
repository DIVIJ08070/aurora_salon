import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../viewmodel/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LoginVC>()) {
      Get.put(LoginVC(), permanent: true);
    }

    final controller = Get.put(SplashController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D0D), Color(0xFF1C1C1C)],
          ),
        ),
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: ScaleTransition(
            scale: controller.scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC5A059).withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/salon_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.content_cut_rounded,
                        size: 80,
                        color: Color(0xFFC5A059),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'AURORA',
                  style: TextStyle(
                    color: Color(0xFFC5A059),
                    fontSize: 42,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 12,
                  ),
                ),
                const Text(
                  'SALON & SPA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 80),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFC5A059),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
