import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/viewmodel/service_controller.dart';
import '../../services/view/service_detail_screen.dart';
import '../viewmodel/home_controller.dart';

class ServicesGridScreen extends StatelessWidget {
  final ServiceController serviceController;
  final HomeController homeController;
  final String Function(int) getRotatingImage;

  const ServicesGridScreen({
    super.key,
    required this.serviceController,
    required this.homeController,
    required this.getRotatingImage,
  });

  static const _bg = Color(0xFF0D0D0D);
  static const _gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ALL SERVICES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w200,
            letterSpacing: 4,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (serviceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: _gold));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: serviceController.services.length,
          itemBuilder: (context, index) {
            final service = serviceController.services[index];
            final isSelected = service.name == homeController.selectedCategory.value;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.to(
                  () => ServiceDetailScreen(
                    service: service,
                    imagePath: getRotatingImage(index),
                  ),
                  transition: Transition.rightToLeftWithFade,
                ),
                borderRadius: BorderRadius.circular(24),
                splashColor: _gold.withValues(alpha: 0.2),
                highlightColor: _gold.withValues(alpha: 0.1),
                child: Hero(
                  tag: 'service_img_${service.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? _gold : Colors.white.withValues(alpha: 0.05),
                          width: isSelected ? 2 : 1,
                        ),
                        image: DecorationImage(
                          image: AssetImage(getRotatingImage(index)),
                          fit: BoxFit.cover,
                          opacity: isSelected ? 0.7 : 0.3,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              service.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

