import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../auth/viewmodel/loginvc.dart';
import '../../services/viewmodel/service_controller.dart';
import '../../stylists/viewmodel/stylist_controller.dart';
import '../../booking/view/appointments_tab.dart';
import '../viewmodel/home_controller.dart';
import 'widgets/artist_section.dart';
import 'widgets/profile_tab.dart';
import 'widgets/home_hero_section.dart';
import 'widgets/home_service_section.dart';
import 'widgets/nearby_salons_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _bg = Color(0xFF0D0D0D);
  static const _gold = Color(0xFFC5A059);

  String _getStylistImage(int index) {
    final images = [
      'assets/stylist1.png',
      'assets/stylist2.png',
      'assets/stylist3.png',
      'assets/stylist4.png',
      'assets/stylist5.png',
    ];
    return images[index % images.length];
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

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginVC>();
    final serviceController = Get.put(ServiceController());
    final stylistController = Get.put(StylistController());
    final homeController = Get.put(HomeController());

    final user = loginController.user.value;
    final name = (user?.name != null && user!.name.isNotEmpty)
        ? user.name
        : (user?.email.split('@').first.capitalizeFirst ?? 'Guest');

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: Obx(
          () => IndexedStack(
            index: homeController.currentIndex.value,
            children: [
              _buildHomeDashboard(
                name,
                serviceController,
                stylistController,
                homeController,
              ),
              const AppointmentsTab(),
              const Center(
                child: Text(
                  'Favorites coming soon',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              const Center(
                child: Text(
                  'Messages coming soon',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ProfileTab(loginController: loginController),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.booking),
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
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: _bg,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: _gold,
            unselectedItemColor: Colors.white38,
            currentIndex: homeController.currentIndex.value,
            onTap: (index) => homeController.changeTab(index),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeDashboard(
    String name,
    ServiceController serviceController,
    StylistController stylistController,
    HomeController homeController,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeroSection(homeController: homeController, userName: name),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeServiceSection(
                  serviceController: serviceController,
                  homeController: homeController,
                  getRotatingImage: _getRotatingImage,
                ),
                const SizedBox(height: 32),
                ArtistSection(
                  stylistController: stylistController,
                  getStylistImage: _getStylistImage,
                ),
                const SizedBox(height: 32),
                const NearbySalonsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
