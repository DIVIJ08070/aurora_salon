import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/theme_controller.dart';
import '../repository/auth_service.dart';
import '../model/userdata.dart';
import '../../../core/storage/storage_service.dart';
import 'dart:convert';
import '../../../routes/app_pages.dart';

class LoginVC extends GetxController {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var errorMessage = ''.obs;
  var user = Rxn<Userdata>();

  var email = ''.obs;
  var password = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var isFormValid = false.obs;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () => checkLogin());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void handleLogin() async {
    final success = await login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (success) {
      emailController.clear();
      passwordController.clear();
      Get.offAllNamed(Routes.home);
    }
  }

  Future<void> checkLogin() async {
    try {
      final hasTokens = await _storageService.hasTokens();
      if (!hasTokens) {
        isLoggedIn.value = false;
        Get.offAllNamed(Routes.login);
        return;
      }

      // Try to get existing token
      final token = await _storageService.getAccessToken();
      if (token != null) {
        final profile = await _authService.fetchProfile(token);
        if (profile != null) {
          user.value = profile;
          isLoggedIn.value = true;
          
          // Save updated profile to prefs
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userData', jsonEncode(profile.toJson()));
          
          Get.offAllNamed(Routes.home);
          return;
        }
      }

      // If profile fetch fails, try to refresh
      final refreshSuccess = await _authService.refreshTokens();

      if (refreshSuccess) {
        final prefs = await SharedPreferences.getInstance();
        isLoggedIn.value = true;

        final userJson = prefs.getString('userData');
        if (userJson != null) {
          try {
            user.value = Userdata.fromJson(jsonDecode(userJson));
          } catch (e) {
            debugPrint('Error parsing user data: $e');
          }
        }
        Get.offAllNamed(Routes.home);
      } else {
        // Only clear if refresh explicitly fails (e.g. invalid refresh token)
        // If it's a connection error, we might want to keep the tokens, 
        // but for now let's stick to the secure path of logging out if refresh fails.
        await _storageService.clearTokens();
        isLoggedIn.value = false;
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      debugPrint('CheckLogin Error: $e');
      Get.offAllNamed(Routes.login);
    }
  }

  Future<bool> login(String email, String password) async {
    _validateEmail(email);
    _validatePassword(password);
    _updateFormValid();
    if (!isFormValid.value) return false;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authService.login(email, password);

      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        if (result['user'] != null) {
          user.value = result['user'] as Userdata;

          await prefs.setString('userData', jsonEncode(user.value!.toJson()));
        }

        isLoggedIn.value = true;
        return true;
      } else {
        errorMessage.value = result['message'];
        Get.snackbar(
          'Login Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void setEmail(String value) {
    email.value = value;
    _validateEmail(value);
    _updateFormValid();
  }

  void setPassword(String value) {
    password.value = value;
    _validatePassword(value);
    _updateFormValid();
  }

  void _validateEmail(String value) {
    final regex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!regex.hasMatch(value)) {
      emailError.value = 'Enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  void _updateFormValid() {
    isFormValid.value =
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        email.value.isNotEmpty &&
        password.value.isNotEmpty;
  }

  Future<void> normalLogout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {

      await _authService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userData');

      user.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed(Routes.login);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> hardLogout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {

      await _authService.logout();
      await _storageService.clearTokens();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      user.value = null;
      isLoggedIn.value = false;

      Get.find<ThemeController>().resetTheme();
      Get.offAllNamed(Routes.login);
    } finally {
      isLoading.value = false;
    }
  }
}
