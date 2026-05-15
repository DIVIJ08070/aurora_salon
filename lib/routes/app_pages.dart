import 'package:get/get.dart';
import '../features/splashscreen/view/splash_screen.dart';
import '../features/auth/view/loginui.dart';
import '../features/home/view/home_screen.dart';
import '../features/booking/view/booking_wizard.dart';

abstract class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const booking = '/booking';
}

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.login,
      page: () => const LoginUI(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.booking,
      page: () => const BookingWizard(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
