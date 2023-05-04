import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/screen_controller.dart';
import 'package:insta_cable/view/reel_screen.dart';
import 'package:insta_cable/view/upload_screen.dart';

List<Widget> _pages = [UploadScreen(), ReelScreen()];
List<BottomNavigationBarItem> _barItems = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Reels')
];
Widget buildBottomBar(ScreenController controller) => Obx(
      () => BottomNavigationBar(
        items: _barItems,
        selectedItemColor: Colors.greenAccent,
        currentIndex: controller.index.value,
        onTap: (value) {
          controller.changeIndex(value);
        },
      ),
    );

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});

  ScreenController controller = Get.put(ScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.index.value]),
      bottomNavigationBar: buildBottomBar(controller),
    );
  }
}
