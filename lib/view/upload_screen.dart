import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:insta_cable/controller/upload_controller.dart';
import 'package:insta_cable/view/components/posts_grid_view.dart';
import 'package:insta_cable/view/create_new_reel.dart';

import '../controller/auth_controller.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final UploadController videoController = Get.put(UploadController());

    return SafeArea(
      child: Scaffold(
          body: const PostsGridView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final videoFile = await videoController.pickVideo();
              if (videoFile == null) {
                return;
              } else {
                Get.off(CreateNewReelScreen(video: videoFile));
              }
            },
            backgroundColor: Colors.greenAccent,
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
          ),
          appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      authController.logout();
                    },
                    icon: const Icon(Icons.logout))
              ],
              title: const Text(
                "My Reels",
              ))),
    );
  }
}
