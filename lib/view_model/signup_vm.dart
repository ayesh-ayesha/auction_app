import 'package:auction_app/repositories/user_profile_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/user_profile.dart';
import '../repositories/auth_repo.dart';

class SignUpViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  UserProfileRepository userProfileRepository = Get.find();
  UserProfile? userProfile;


  var isLoading = false.obs;
  var isAdmin = false.obs;
  var isBidder = false.obs;


  Future<void> signup(String email, String password, String confirmPassword,String displayName) async {
    if (!email.contains('@')) {
      Get.snackbar("Error", "Invalid Email");
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "password and confirm password must match");
      return;
    }



    if (displayName.isEmpty) {
      Get.snackbar("Error", "Enter Display name");
      return;
    }
    isLoading.value = true;


    try {
      UserCredential credential = await authRepository.signUp(email, password);
      String uid = credential.user!.uid;
      userProfile = UserProfile(
          id: uid,
          email: email,
          displayName: displayName,
          isBidder: isBidder.value,
          isAdmin: isAdmin.value);
      await userProfileRepository.addUserProfile(userProfile!);


      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? 'SignUp Failed');

      //error
    } finally {
      isLoading.value = false;
    }
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }


}