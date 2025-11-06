part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const userPage = _Paths.userPage;
  static const loginPage = _Paths.loginPage;
  static const splashscreen = _Paths.splashscreen;

}

abstract class _Paths {
  _Paths._();
  static const userPage = '/userpage';
  static const loginPage = '/loginpage';
  static const splashscreen = '/splashscreen';

}
