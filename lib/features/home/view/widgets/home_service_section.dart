import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/viewmodel/service_controller.dart';
import '../../../services/view/service_detail_screen.dart';
import '../../viewmodel/home_controller.dart';
import '../services_grid_screen.dart';
import 'gold_shimmer_widget.dart';

class HomeServiceSection extends StatelessWidget {
  final ServiceController serviceController;
  final HomeController homeController;
  final String Function(int) getRotatingImage;

  const HomeServiceSection({
    super.key,
    required this.serviceController,
    required this.homeController,
    required this.getRotatingImage,
  });

  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                color: _text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.to(
                () => ServicesGridScreen(
                  serviceController: serviceController,
                  homeController: homeController,
                  getRotatingImage: getRotatingImage,
                ),
              ),
              child: const Text(
                'See all',
                style: TextStyle(color: _gold, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildServiceList(),
      ],
    );
  }

  Widget _buildServiceList() {
    return SizedBox(
      height: 110,
      child: Obx(() {
        if (serviceController.isLoading.value) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(right: 12),
                child: GoldShimmerWidget(
                  width: 140,
                  height: 110,
                  borderRadius: 16,
                ),
              );
            },
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: serviceController.services.length,
          itemBuilder: (context, index) {
            final service = serviceController.services[index];
            final isSelected =
                service.name == homeController.selectedCategory.value;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.to(
                    () => ServiceDetailScreen(
                      service: service,
                      imagePath: getRotatingImage(index),
                    ),
                    transition: Transition.rightToLeftWithFade,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: _gold.withValues(alpha: 0.2),
                  highlightColor: _gold.withValues(alpha: 0.1),
                  child: Hero(
                    tag: 'service_img_${service.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Ink(
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? _gold : Colors.transparent,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: AssetImage(getRotatingImage(index)),
                            fit: BoxFit.cover,
                            opacity: isSelected ? 0.8 : 0.4,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            service.name.toUpperCase(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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

