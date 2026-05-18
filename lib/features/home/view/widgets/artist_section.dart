import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../stylists/view/stylist_detail_screen.dart';
import '../../../stylists/viewmodel/stylist_controller.dart';
import 'stylist_card.dart';
import 'gold_shimmer_widget.dart';

class ArtistSection extends StatelessWidget {
  final StylistController stylistController;
  final String Function(int) getStylistImage;

  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;
  static const _subtext = Colors.white54;

  const ArtistSection({
    super.key,
    required this.stylistController,
    required this.getStylistImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Stylists',
              style: TextStyle(
                color: _text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('See all', style: TextStyle(color: _gold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
        height: 220,
          child: Obx(() {
            if (stylistController.isLoading.value) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: GoldShimmerWidget(
                      width: 160,
                      height: 220,
                      borderRadius: 24,
                    ),
                  );
                },
              );
            }
            if (stylistController.stylists.isEmpty) {
              return const Center(
                child: Text(
                  'No artists available',
                  style: TextStyle(color: _subtext),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stylistController.stylists.length,
              itemBuilder: (context, index) {
                final stylist = stylistController.stylists[index];
                final imagePath = getStylistImage(index);
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: StylistCard(
                    image: imagePath,
                    name: stylist.name,
                    role:
                        stylist.specialisation
                            .replaceAll('_', ' ')
                            .capitalizeFirst ??
                        '',
                    exp: 'Active',
                    rating: 4.9,
                    onTap: () {
                      Get.to(
                        () => StylistDetailScreen(
                          stylist: stylist,
                          imagePath: imagePath,
                        ),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    heroTag: 'stylist_img_${stylist.id}',
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
