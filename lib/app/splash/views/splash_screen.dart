import 'package:dio_package/app/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Delay the navigation until after build

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text("Splash")
      ],),
    );
  }
}
