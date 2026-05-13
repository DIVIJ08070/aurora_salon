import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../../services/viewmodel/service_controller.dart';
import '../../stylists/viewmodel/stylist_controller.dart';
import '../../booking/view/appointments_tab.dart';
import 'widgets/artist_section.dart';
import 'widgets/home_header.dart';
import 'widgets/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'Haircuts';
  bool _isPremiumMode = false;

  // Carousel Logic
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  final int _numPages = 2;

  static const _bg = Color(0xFF0D0D0D);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _numPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuint,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _getStylistImage(int index) {
    final images = ['assets/stylist1.png', 'assets/stylist2.png', 'assets/stylist3.png', 'assets/stylist4.png', 'assets/stylist5.png'];
    return images[index % images.length];
  }

  String _getRotatingImage(int index) {
    final images = ['assets/cat_haircut.png', 'assets/cat_color.png', 'assets/cat_nails.png', 'assets/cat_makeup.png', 'assets/cat_skin.png', 'assets/cat_spa.png'];
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginVC>();
    final serviceController = Get.put(ServiceController());
    final stylistController = Get.put(StylistController());
    final user = loginController.user.value;
    final name = (user?.name != null && user!.name.isNotEmpty) ? user.name : (user?.email.split('@').first.capitalizeFirst ?? 'Guest');

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeDashboard(name, serviceController, stylistController),
            const AppointmentsTab(),
            const Center(child: Text('Favorites coming soon', style: TextStyle(color: Colors.white54))),
            const Center(child: Text('Messages coming soon', style: TextStyle(color: Colors.white54))),
            ProfileTab(loginController: loginController),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.BOOKING),
        backgroundColor: _gold,
        icon: const Icon(Icons.add_task_rounded, color: Colors.black),
        label: const Text(
          'BOOK NOW',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _bg,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _gold,
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _buildHomeDashboard(String name, ServiceController serviceController, StylistController stylistController) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ZOMATO STYLE HERO SECTION
          Stack(
            children: [
              // Background Banner Carousel
              SizedBox(
                height: 420,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _buildHeroBackground('assets/banner.png'),
                    _buildHeroBackground('assets/banner2.png'),
                  ],
                ),
              ),
              // Top UI Overlay
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // 1. Header: Location & Profile
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text('Arora Luxe', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                    Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                                  ],
                                ),
                                const Text('Bhulka Bhavan, Anand Mahal Rd, Honey...', style: TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildCircleIcon(Icons.account_balance_wallet_rounded),
                          const SizedBox(width: 8),
                          _buildProfilePic(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // 2. Search & "ARORA" Branding
                      Row(
                        children: [
                          Expanded(
                            child: _buildZomatoSearchBar(),
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
                      ),
                    ],
                  ),
                ),
              ),
              // 4. Page Indicator (Moved up slightly for a cleaner look)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_numPages, (index) => _buildIndicator(index)),
                ),
              ),
            ],
          ),

          // DASHBOARD CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Services', style: TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildServiceList(serviceController),
                const SizedBox(height: 32),
                ArtistSection(stylistController: stylistController, getStylistImage: _getStylistImage),
                const SizedBox(height: 32),
                _buildNearbySalons(),
              ],
            ),
          ),
        ],
      ),
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
            colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
      ),
    );
  }

  Widget _buildZomatoSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: const [
          Icon(Icons.search, color: _gold, size: 22),
          SizedBox(width: 10),
          Expanded(child: Text('Search "Haircuts"', style: TextStyle(color: Colors.white38, fontSize: 14))),
          Icon(Icons.mic_none_rounded, color: Colors.white54, size: 22),
        ],
      ),
    );
  }

  Widget _buildBannerContent() {
    final isPageOne = _currentPage == 0;
    return Column(
      children: [
        Text(
          isPageOne ? 'ELITE GROOMING' : 'AURORA LUXE',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
          ),
        ),
        Text(
          isPageOne ? '20% OFF' : 'FREE FACIAL',
          style: const TextStyle(
            color: _gold,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isPageOne ? 'HAIRCUT & BEARD COMBO' : 'GOLD INFUSED TREATMENT',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Get.toNamed(Routes.BOOKING),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'BOOK NOW',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 8,
      height: 4,
      decoration: BoxDecoration(color: _currentPage == index ? Colors.white : Colors.white24, borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildProfilePic() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24, width: 2)),
      child: const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/stylist1.png')),
    );
  }

  Widget _buildServiceList(ServiceController controller) {
    return SizedBox(
      height: 110,
      child: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: _gold));
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];
            final isSelected = service.name == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = service.name),
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? _gold : Colors.transparent, width: 2),
                  image: DecorationImage(image: AssetImage(_getRotatingImage(index)), fit: BoxFit.cover, opacity: isSelected ? 0.8 : 0.4),
                ),
                child: Center(
                  child: Text(service.name.toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildNearbySalons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Nearby Salons', style: TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('See all', style: TextStyle(color: _gold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: const DecorationImage(image: AssetImage('assets/salon_interior.png'), fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.9), Colors.transparent])),
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('The Gilded Blade', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.location_on, color: _gold, size: 14),
                    SizedBox(width: 4),
                    Text('1.2 km away', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
