import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/auth_controller.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/view/bottom_nav_bar.dart';
import 'package:insta_cable/view/create_new_reel.dart';
import 'package:insta_cable/view/reel_screen.dart';
import 'package:insta_cable/view/upload_screen.dart';

import 'firebase_options.dart';
import 'view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    DataController dataController = Get.put(DataController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
              elevation: 0)),
      home: const Center(child: CircularProgressIndicator()),
    );
  }
}

// Firebase phone authentication
// A reels page that gets reels from an API call (db can be hosted anywhere, 
//you can use firestore for simplicity), 10 reels at a time and a new api call should be 
//made when the user reaches the last/second last reel. 
//When making an API call, show a toast on the screen saying “making API call”. 
//There should be 40-50 reels with the basic schema: title, description, videoLink, 
//uid (user id of creator), nLikes (number of likes). And an option to like.
// A user can like/dislike a reel but the like should not be counted n number of times. 
//The video should play by default, on tapping it should go on mute and on holding 
//the tap, it should pause and the description and title should be hidden
// A screen to upload reels
