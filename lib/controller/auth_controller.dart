import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_cable/view/bottom_nav_bar.dart';
import 'package:insta_cable/view/login_screen.dart';
import 'package:insta_cable/view/welcome_screen.dart';

class AuthController extends GetxController {
  var _auth = FirebaseAuth.instance;
  var isOtpSent = false.obs;
  var numberController = TextEditingController().obs;
  late final Rx<User?> firebaseUser;
  var verifId = "".obs;
  var otpController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future login() async {
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: "+91${numberController.value.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        String msg = e.code;
        String submsg = '';
        if (e.code == 'invalid-phone-number') {
          submsg = "Please enter a valid phone number";
        }
        if (e.code == 'too-many-requests') {
          submsg = "Please try again later";
        }
        showSnackbar(msg: msg, submsg: submsg);
      },
      codeSent: (String verificationId, int? resendToken) async {
        isOtpSent.value = true;
        verifId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackbar(msg: 'Code retrieval timed out', submsg: 'Please retry');
      },
    );
  }

  Future verifyOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifId.value, smsCode: otpController.value.text);
      await _auth.signInWithCredential(credential);
      Get.off(const LandingScreen());
    } catch (e) {
      print(e);
    }
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => const LandingScreen());
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

void showSnackbar({required String msg, required String submsg}) {
  GetSnackBar snackbar = GetSnackBar(
    duration: const Duration(seconds: 30),
    titleText: Text(msg),
    messageText: Text(submsg),
  );
  Get.showSnackbar(snackbar);
}

// final isLoggedIn = false.obs();
//   final auth = FirebaseAuth.instance.obs();
//   final numberController = TextEditingController().obs;

