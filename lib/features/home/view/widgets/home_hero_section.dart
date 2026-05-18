import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/home_controller.dart';

class HomeHeroSection extends StatelessWidget {
  final HomeController homeController;
  final String userName;

  const HomeHeroSection({
    super.key,
    required this.homeController,
    required this.userName,
  });

  static const _gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Banners
        SizedBox(
          height: 420,
          child: PageView(
            controller: homeController.pageController,
            onPageChanged: (index) => homeController.onPageChanged(index),
            children: [
              _buildHeroBackground('assets/banner.png'),
              _buildHeroBackground('assets/banner2.png'),
            ],
          ),
        ),

        // Header Overlay
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildLocationHeader(),
                const SizedBox(height: 20),
                _buildSearchBar(),
              ],
            ),
          ),
        ),

        // Page Indicator
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                homeController.numPages,
                (index) => _buildIndicator(
                  index,
                  homeController.currentPage.value,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBackground(String image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Arora Luxe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                ],
              ),
              const Text(
                'Bhulka Bhavan, Anand Mahal Rd, Honey...',
                style: TextStyle(color: Colors.white70, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildCircleIcon(Icons.account_balance_wallet_rounded),
        const SizedBox(width: 8),
        _buildProfilePic(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Icon(Icons.search, color: _gold, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search "Haircuts"',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ),
                Icon(Icons.mic_none_rounded, color: Colors.white54, size: 22),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'ARORA',
              style: TextStyle(
                color: _gold,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Text(
              'LUXE',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicator(int index, int currentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentPage == index ? 16 : 8,
      height: 4,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.white : Colors.white24,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildProfilePic() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: const CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage('assets/stylist1.png'),
      ),
    );
  }
}
