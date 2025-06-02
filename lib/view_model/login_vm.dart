import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../repositories/auth_repo.dart';

class LoginViewModel extends GetxController {
  AuthRepository authRepository=Get.find();
  var isLoading=false.obs;

  Future<void> login(String email,String password) async {
    if (!email.contains('@')){
      Get.snackbar("Error", "Invalid Email");
      return;
    }
    if (password.length<6){
      Get.snackbar("Error", "password should be atleast 6 characters");
      return;
    }
    isLoading.value=true;
    try{
      await authRepository.login(email, password);
      Get.offAllNamed('/home');
    }on FirebaseAuthException catch(e){
      Get.snackbar("Error", e.message??'Login Failed');

      //error
    }finally{
      isLoading.value=false;

    }

  }
  bool isUserLoggedIn(){
    return authRepository.getLoggedInUser()!=null;
  }

  void logout(){
    authRepository.logout();
    Get.offAllNamed('/login');
  }

  String? getCurrentUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid; // Returns the Firebase user ID
  }

}