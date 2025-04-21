import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio_package/model/userresponse_model.dart';
import 'package:dio_package/reusability/utills/app_constants.dart';
import 'package:dio_package/reusability/utills/firebase/firebase_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../reusability/utills/network_dio/network_dio.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  RxList<UserResponseModel> userList = <UserResponseModel>[].obs;
  RxBool isLoading = false.obs;

  final box = GetStorage();
  final ScrollController scrollController = ScrollController();
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();
  final FirebaseUserManager firebaseUserManager = FirebaseUserManager();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // void fetchUsers() async {
  //   final response = await networkDioHttp.getRequest(
  //     url: ApiAppConstants.apiEndPoint + ApiAppConstants.user,
  //     isHeader: false,
  //     name: 'UserList',
  //     isBearer: false,
  //   );
  //
  //   if (response != null && response.statusCode == 200) {
  //     isLoading.value = true;
  //
  //     List<UserResponseModel> users =
  //         (response.data as List).map((e) => UserResponseModel.fromJson(e)).toList();
  //
  //     firebaseUserManager.uploadUsers(users);
  //     userList.value = await firebaseUserManager.getAllUsers();
  //     print("User List: ${userList}");
  //   }
  //   isLoading.value = false;
  // }

  void fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await networkDioHttp.getRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.user,
        isHeader: false,
        name: 'UserList',
        isBearer: false,
      );

      if (response != null && response.statusCode == 200) {
        List<UserResponseModel> users =
        (response.data as List).map((e) => UserResponseModel.fromJson(e)).toList();

        firebaseUserManager.uploadUsers(users);
        userList.value = await firebaseUserManager.getAllUsers();
        print("User List: ${userList}");
      } else {
        print("Failed to fetch users. Status Code: ${response?.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error fetching users: $e");
      print("StackTrace: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser({required UserResponseModel user}) async {

    try {
      await firebaseUserManager.updateUser(user);
      // Do something with users
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await firebaseUserManager.deleteUser(userId);
      // Do something with users
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
