import 'package:auction_app/repositories/user_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repositories/auth_repo.dart';
import '../view_model/signup_vm.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  bool isPasswordVisible = false;

  late SignUpViewModel signUpViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signUpViewModel = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (signUpViewModel.isUserLoggedIn()) {
        Get.offAllNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text("SignUp to continue"),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.hide_source
                        : Icons.remove_red_eye,
                  ),
                ),
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                hintText: "Enter Password again",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.hide_source
                        : Icons.remove_red_eye,
                  ),
                ),
              ),
            ),
            TextField(
              controller: displayNameController,
              decoration: InputDecoration(
                labelText: "Display name",
                hintText: "Enter your name",
                prefixIcon: Icon(Icons.abc_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            Obx(() {
              return signUpViewModel.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () {
                      signUpViewModel.signup(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                        displayNameController.text,
                      );
                    },
                    child: Text("SignUp"),
                  );
            }),
          ],
        ),
      ),
    );
  }
}

class SignupDependency extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(SignUpViewModel());
    Get.put(UserProfileRepository());
  }
}
