import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/auth_controller.dart';

import '../constants/app_colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                        controller: authController.otpController.value,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: "Enter OTP",
                            border: OutlineInputBorder(gapPadding: 10)),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent),
                          onPressed: () async {
                            authController.verifyOtp();
                          },
                          child: const Text("VERIFY"))
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
  "Verification",
  style: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'Satisfy',
      foreground: Paint()..shader = linearGradient),
  textScaleFactor: 3.5,
);

Widget _loginMsg = const Text(
  "Enter the OTP you received",
  style: TextStyle(fontFamily: 'Satisfy', color: Colors.black),
  textScaleFactor: 1.5,
);
