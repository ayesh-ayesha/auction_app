import 'package:auction_app/repositories/user_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repositories/auth_repo.dart';
import '../view_model/login_vm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  bool isPasswordVisible = false;
  late LoginViewModel loginViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginViewModel = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loginViewModel.isUserLoggedIn()) {
        Get.offAllNamed('/home');
      }
    });
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
            Text("Login to continue"),
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

            Obx(() {
              return loginViewModel.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () {
                      loginViewModel.login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: Text("Login"),
                  );
            }),
            TextButton(
              onPressed: () {
                Get.offAllNamed('/signup');
              },
              child: Text("Don't have an account? SignUp"),
            ),
            TextButton(
              onPressed: () {
                // Get.toNamed('/forget_password',arguments: emailController.text);
                Get.toNamed(
                  '/forget_password',
                  arguments: {'email': emailController.text, 'flag': 1},
                );
              },
              child: Text("Forget Password"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(LoginViewModel());
    Get.put(UserProfileRepository());
  }
}
