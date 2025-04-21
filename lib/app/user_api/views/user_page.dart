import 'package:dio_package/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../reusability/utills/app_colors.dart';
import '../../login/controllers/login_controller.dart';
import '../controller/user_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // late final UserController controller;
  // late final LoginController loginController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller = Get.put(UserController());
    // loginController = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    LoginController loginController = Get.put(LoginController());
    User? user = LoginController.firebaseAuth.currentUser;
    return GestureDetector(
      onTap: () {
        return FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CircleAvatar(
              //   backgroundImage: NetworkImage(user?.photoURL ?? ''),
              //   radius: 40,
              // ),
              const SizedBox(height: 10),
              Text("Name: ${user?.displayName}"),
              Text("Email: ${user?.email}"),
              const SizedBox(height: 20),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("User"),
          actions: [
            IconButton(
              onPressed: () {
                loginController.signOut();
              },
              icon: const Icon(CupertinoIcons.power),
            ),
          ],
        ),
        body: Obx(() {
          print("isLoading: ${userController.isLoading.value}");

          if (userController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.blackColor,
                backgroundColor: AppColors.yellowColor,
              ),
            );
          }

          // if (controller.userList.isEmpty) {
          //   return const Center(child: Text("No users found."));
          // }
          return ListView.builder(
            itemCount: userController.userList.length,
            itemBuilder: (context, index) {
              logger.i("==============length:${userController.userList.length}=============");
              final user = userController.userList[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Show dialog to edit user
                        showDialog(
                          context: context,
                          builder: (context) {
                            final nameController = TextEditingController(text: user.name);
                            final emailController = TextEditingController(text: user.email);
                            return AlertDialog(
                              title: const Text('Edit User'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    user.email = emailController.text;
                                    user.name = nameController.text;
                                    userController.userList[index] = user;
                                    userController.updateUser(user: user);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Save',
                                    style:
                                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete User'),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Are you sure you want to delete user??"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    userController.userList.removeAt(index);
                                    userController.deleteUser(user.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: AppColors.redColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );

          // return ListView.builder(
          //   itemCount: controller.userList.length,
          //   itemBuilder: (context, index) {
          //     final user = controller.userList[index];
          //     return ListTile(
          //       title: Text(user.name),
          //       subtitle: Text(user.email),
          //       trailing: Text(user.phone),
          //     );
          //   },
          // );
        }),
      ),
    );
  }
}
