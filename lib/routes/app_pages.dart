import 'package:get/get.dart';
import '../features/splashscreen/view/splash_screen.dart';
import '../features/auth/view/loginui.dart';
import '../features/home/view/home_screen.dart';

abstract class Routes {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
}

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginUI(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      transition: Transition.cupertino,
    ),
  ];
}
