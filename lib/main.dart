import 'package:dio_package/app/login/controllers/login_controller.dart';
import 'package:dio_package/reusability/utills/app_colors.dart';
import 'package:dio_package/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

GetStorage dataStorage = GetStorage();
Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetStorage
  await GetStorage.init();
  final LoginController loginController = Get.put(LoginController());

  runApp(GetMaterialApp(
    title: "Dio App",
    debugShowCheckedModeBanner: false,
    initialRoute: loginController.isLoggedIn.value ? AppPages.user : AppPages.initial,
    getPages: AppPages.routes,
    // theme: ThemeData(
    //   primaryColor: AppColors.primaryColor,
    //   colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
    //   buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
    // ),
  ));
}
