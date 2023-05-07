import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:insta_cable/constants/app_colors.dart';
import 'package:insta_cable/controller/auth_controller.dart';
import 'package:insta_cable/view/bottom_nav_bar.dart';
import 'package:insta_cable/view/reel_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _title,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _loginMsg,
                      TextFormField(
                        controller: authController.numberController.value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            prefix: Text(
                              '(+91)',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            hintText: "Enter your phone number",
                            border: OutlineInputBorder(gapPadding: 10)),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent),
                          onPressed: () async {
                            authController.isOtpSent.value = true;
                            authController.login();
                          },
                          child: const Text("SUBMIT"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _title = Text(
  "Instacable",
  style: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'Satisfy',
      foreground: Paint()..shader = linearGradient),
  textScaleFactor: 3.5,
);

Widget _loginMsg = const Text(
  "Login/Signup using your phone",
  style: TextStyle(fontFamily: 'Satisfy', color: Colors.black),
  textScaleFactor: 1.5,
);
