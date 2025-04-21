import 'package:dio_package/app/login/views/login_page.dart';
import 'package:dio_package/app/splash/views/splash_screen.dart';
import 'package:dio_package/app/user_api/views/user_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  // static String initial = Routes.splash;
  static String initial = Routes.loginPage;
  static String user = Routes.userPage;

  static final routes = [
    GetPage(
      name: _Paths.userPage,
      page: () => const UserPage(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.loginPage,
      page: () =>  const LoginPage(),
      // binding: SplashBinding(),
    ), GetPage(
      name: _Paths.splashscreen,
      page: () =>  const SplashScreen(),
      // binding: SplashBinding(),
    ),

  ];
}
