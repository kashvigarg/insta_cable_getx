import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_cable/constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: "Enter your phone number",
                            border: OutlineInputBorder(gapPadding: 10)),
                      )
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
