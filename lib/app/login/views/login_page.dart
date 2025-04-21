import 'package:dio_package/app/login/controllers/login_controller.dart';
import 'package:dio_package/reusability/utills/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValueNotifier userCredential = ValueNotifier('');
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google SignIn Screen')),
      body: ValueListenableBuilder(
          valueListenable: userCredential,
          builder: (context, value, child) {
            return (userCredential.value == '' || userCredential.value == null)
                ? Center(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.g_mobiledata),
                        onPressed: () async {
                          userCredential.value = await loginController.signInWithGoogle();
                          if (userCredential.value != null) print(userCredential.value.user!.email);
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1.5, color: Colors.black54)),
                          child: Image.network(userCredential.value.user!.photoURL.toString()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(userCredential.value.user!.displayName.toString()),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(userCredential.value.user!.email.toString()),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await loginController.signOut();
                            // bool result = await signOutFromGoogle();
                            // if (result) userCredential.value = '';
                          },
                          child: const Text('Logout',style: TextStyle(color: AppColors.blackColor),),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
