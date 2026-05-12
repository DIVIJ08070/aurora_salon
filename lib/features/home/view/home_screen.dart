import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../../services/viewmodel/service_controller.dart';
import '../../stylists/viewmodel/stylist_controller.dart';
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

  // Aurora Theme Colors
  static const _bg = Color(0xFF1A1A1A);
  static const _card = Color(0xFF2D2D2D);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;
  static const _subtext = Colors.white54;

  String _getImageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'hair':
        return 'assets/cat_haircut.png';
      case 'color':
        return 'assets/cat_color.png';
      case 'nails':
        return 'assets/cat_nails.png';
      case 'makeup':
        return 'assets/cat_makeup.png';
      case 'skin':
        return 'assets/cat_skin.png';
      case 'spa':
        return 'assets/cat_spa.png';
      default:
        return 'assets/salon_logo.png';
    }
  }

  String _getRotatingImage(int index) {
    final images = [
      'assets/cat_haircut.png',
      'assets/cat_color.png',
      'assets/cat_nails.png',
      'assets/cat_makeup.png',
      'assets/cat_skin.png',
      'assets/cat_spa.png',
    ];
    return images[index % images.length];
  }

  String _getStylistImage(int index) {
    final images = ['assets/stylist1.png', 'assets/stylist2.png'];
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginVC>();
    final serviceController = Get.put(ServiceController());
    final stylistController = Get.put(StylistController());
    final email = loginController.userEmail.value;
    final name = email.split('@').first.capitalizeFirst ?? 'Guest';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: _currentIndex == 0
            ? _buildHomeDashboard(name, serviceController, stylistController)
            : ProfileTab(loginController: loginController),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _bg,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _gold,
        unselectedItemColor: _subtext,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _buildHomeDashboard(
    String name,
    ServiceController serviceController,
    StylistController stylistController,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(name: name),
          const SizedBox(height: 24),

          // Special Offers
          const SizedBox(height: 16),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/banner.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Haircut & Beard',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '20% Off',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jul 16 - Jul 24',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Get Offer Now',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Services',
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Services (Replaced dummy categories)
          SizedBox(
            height: 90, // Taller for image cards
            child: Obx(() {
              if (serviceController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: _gold),
                );
              }

              if (serviceController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      serviceController.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (serviceController.services.isEmpty) {
                return const Center(
                  child: Text(
                    'No services found.',
                    style: TextStyle(color: _subtext),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: serviceController.services.length,
                itemBuilder: (context, index) {
                  final service = serviceController.services[index];
                  final isSelected = service.name == _selectedCategory;
                  final image = _getRotatingImage(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = service.name;
                      });
                    },
                    child: Container(
                      width: 140, // Width of image cards
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _gold : Colors.transparent,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(
                            0.5,
                          ), // Dark overlay for text
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          service.name,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 32),

          // Pro Care at Home / Artist Section
          ArtistSection(
            stylistController: stylistController,
            getStylistImage: _getStylistImage,
          ),
          const SizedBox(height: 32),

          // Nearby Salons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Nearby Salons',
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
          Container(
            height: 200,
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/salon_interior.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The Gilded Blade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: _gold, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '1.2 km away',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
