import 'package:flutter/material.dart';

class OtpDialog extends StatelessWidget {
  const OtpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), fillColor: Colors.white),
              ),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "Resend?",
                  style: TextStyle(color: Colors.green),
                  textScaleFactor: 1.2,
                ))
          ],
        ),
      ),
    );
  }
}
