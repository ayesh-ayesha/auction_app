import 'package:auction_app/view/login_screen.dart';
import 'package:auction_app/view/reset_password_screen.dart';
import 'package:auction_app/view/signup.dart';
import 'package:auction_app/view/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: LoginBinding(),
      getPages: [
        GetPage(name: "/login", page: ()=>LoginScreen(),binding: LoginBinding()),
        GetPage(name: "/signup", page: ()=>SignUp(),binding:SignupDependency(),),
        GetPage(name: "/forget_password", page: ()=>ResetPasswordPage(),binding: ResetPasswordBinding()),
        GetPage(name: "/home", page: ()=>HomeScreen(),binding: HomeScreenBinding()),
        // GetPage(name: '/auctionDetailsScreenUser' ,page:()=>AuctionDetailsScreenUser(),binding: AuctionDetailsScreenUserBinding()),
      ],
      initialRoute:'/login' ,



    );
  }
}



