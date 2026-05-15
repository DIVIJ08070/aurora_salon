import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/loginvc.dart';
import '../../theme/theme_controller.dart';

class LoginUI extends StatelessWidget {
  const LoginUI({Key? key}) : super(key: key);

  static const _gold = Color(0xFFC5A059);
  static const _charcoal = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _inputBg = Color(0xFF333333);
  static const _inputBorder = Color(0xFF444444);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginVC>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_charcoal, _charcoalLight],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _gold.withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/salon_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.content_cut_rounded,
                          size: 50,
                          color: _gold,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'AURORA',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 28,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    Obx(() {
                      final themeController = Get.find<ThemeController>();
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _inputBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(
                            themeController.isDarkMode.value
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: _gold,
                            size: 20,
                          ),
                          onPressed: themeController.toggleTheme,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 36),

                const Text(
                  'EMAIL ADDRESS',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: loginController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  onChanged: (v) => loginController.setEmail(v.trim()),
                  cursorColor: _gold,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: _gold.withOpacity(0.6),
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _inputBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _gold, width: 1.5),
                    ),
                    filled: true,
                    fillColor: _inputBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                Obx(() {
                  final msg = loginController.emailError.value;
                  if (msg.isEmpty) return const SizedBox(height: 20);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      msg,
                      style: const TextStyle(
                        color: Color(0xFFE57373),
                        fontSize: 12,
                      ),
                    ),
                  );
                }),

                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: loginController.passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  onChanged: (v) => loginController.setPassword(v),
                  cursorColor: _gold,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: _gold.withOpacity(0.6),
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _inputBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _gold, width: 1.5),
                    ),
                    filled: true,
                    fillColor: _inputBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                Obx(() {
                  final msg = loginController.passwordError.value;
                  if (msg.isEmpty) return const SizedBox(height: 20);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      msg,
                      style: const TextStyle(
                        color: Color(0xFFE57373),
                        fontSize: 12,
                      ),
                    ),
                  );
                }),

                Obx(() {
                  if (loginController.errorMessage.value.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE57373).withOpacity(0.1),
                        border: Border.all(
                          color: const Color(0xFFE57373).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFE57373),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              loginController.errorMessage.value,
                              style: const TextStyle(
                                color: Color(0xFFE57373),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                Obx(() {
                  final enabled = loginController.isFormValid.value &&
                      !loginController.isLoading.value;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: enabled
                          ? const LinearGradient(
                              colors: [Color(0xFFC5A059), Color(0xFFD4AF6E)],
                            )
                          : null,
                      color: enabled ? null : _inputBg,
                      boxShadow: enabled
                          ? [
                              BoxShadow(
                                color: _gold.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: enabled ? loginController.handleLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loginController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _charcoal,
                                ),
                              ),
                            )
                          : Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3,
                                color: enabled
                                    ? _charcoal
                                    : Colors.white.withOpacity(0.3),
                              ),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: Divider(color: _inputBorder, thickness: 0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'AURORA SALON & SPA',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.15),
                          fontSize: 10,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: _inputBorder, thickness: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
