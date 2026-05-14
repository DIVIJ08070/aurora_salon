import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var selectedCategory = 'Haircuts'.obs;
  var isPremiumMode = false.obs;

  late PageController pageController;
  Timer? _timer;
  var currentPage = 0.obs;
  final int numPages = 2;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (currentPage.value < numPages - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuint,
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
