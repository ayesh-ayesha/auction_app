import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repositories/auth_repo.dart';
import '../view_model/reset_password_vm.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController emailController;
  bool isPasswordVisible=false;
  late ResetPasswordVm resetViewModel;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // emailController=TextEditingController(text: Get.arguments);
    Map<String,dynamic> maps=Get.arguments;
    emailController=TextEditingController(text: maps['email']);
    resetViewModel=Get.find();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text("Reset Password"),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),


              ),
            ),

            Obx(() {
              return resetViewModel.isLoading.value?CircularProgressIndicator():
              ElevatedButton(onPressed: (){
                resetViewModel.reset(emailController.text,);
              }, child: Text("Reset"));


            },),

            TextButton(onPressed: (){
              Get.back();
            }, child: Text("Back"))

          ],
        ),
      ),
    );
  }
}

class ResetPasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthRepository(),);
    Get.put(ResetPasswordVm(),);
  }

}