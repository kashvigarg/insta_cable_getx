import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:insta_cable/constants/app_colors.dart';
import 'package:insta_cable/controller/auth_controller.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/view/bottom_nav_bar.dart';
import 'package:insta_cable/view/login_screen.dart';
import 'package:insta_cable/view/otp_screen.dart';
import 'package:insta_cable/view/reel_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return SafeArea(
        child: Scaffold(
      body: Obx(() => authController.isOtpSent.value == true
          ? const OtpScreen()
          : const LoginScreen()),
    ));
  }
}
