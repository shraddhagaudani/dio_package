import 'package:dio_package/main.dart';
import 'package:dio_package/reusability/utills/app_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    // firebaseUser.bindStream(auth.authStateChanges());
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = dataStorage.read(AppStrings.islogin);
    isLoggedIn.value = token != null;
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      // dataStorage.write(AppStrings.islogin, true);
      dataStorage.write(AppStrings.islogin, googleAuth?.accessToken);
      isLoggedIn.value = true;
      Get.offAllNamed(
        Routes.userPage,
        arguments: {
          'name': user?.displayName,
          'email': user?.email,
          'photo': user?.photoURL,
        },
      );

      // return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print('exception->$e');
    }
  }

  // Future signInWithGoogle() async {
  //   try {
  //     final currentUser = firebaseAuth.currentUser;
  //     if (currentUser != null) {
  //       // ✅ User is already logged in
  //       print("User is already logged in: ${currentUser.email}");
  //       Get.offAllNamed(Routes.userPage);
  //     } else {
  //       isLoading.value = true;
  //       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //
  //       if (googleUser != null) {
  //         final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
  //
  //         final credential = GoogleAuthProvider.credential(
  //             accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
  //
  //         UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
  //
  //         User? user = userCredential.user;
  //         dataStorage.write(AppStrings.islogin, true);
  //
  //         Get.offAllNamed(Routes.userPage);
  //       } else {
  //         Get.offAllNamed(Routes.loginPage);
  //       }
  //     }
  //
  //   } catch (e) {
  //     Get.snackbar("Login Failed", e.toString());
  //     print("Login-Error:${e.toString()}");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
      await dataStorage.remove(AppStrings.islogin);
      isLoggedIn.value = false;
      Get.offAllNamed(Routes.loginPage);
    } on Exception catch (e) {
      print("Error:${e.toString()}");
    }
  }
}
