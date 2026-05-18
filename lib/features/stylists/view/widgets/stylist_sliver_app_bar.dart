import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/stylist_model.dart';

class StylistSliverAppBar extends StatelessWidget {
  final StylistModel stylist;
  final String imagePath;

  const StylistSliverAppBar({
    super.key,
    required this.stylist,
    required this.imagePath,
  });

  static const _bg = Color(0xFF0D0D0D);
  static const _charcoalLight = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      backgroundColor: _bg,
      elevation: 0,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 40,
                color: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
                  onPressed: () {
                    Get.snackbar(
                      'Added to Favorites',
                      '${stylist.name} added to your favorites.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: _charcoalLight,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.all(16),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'stylist_img_${stylist.id}',
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    _bg.withValues(alpha: 0.8),
                    _bg,
                  ],
                  stops: const [0.0, 0.4, 0.85, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
