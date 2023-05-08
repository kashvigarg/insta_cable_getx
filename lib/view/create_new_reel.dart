import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/auth_controller.dart';
import 'package:insta_cable/controller/upload_controller.dart';
import 'package:insta_cable/view/bottom_nav_bar.dart';
import 'package:video_player/video_player.dart';

class CreateNewReelScreen extends StatefulWidget {
  const CreateNewReelScreen({super.key, required this.video});

  final File? video;

  @override
  State<CreateNewReelScreen> createState() => _CreateNewReelScreenState();
}

class _CreateNewReelScreenState extends State<CreateNewReelScreen> {
  late VideoPlayerController controller;
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.video!);
    controller.initialize().then(
      (value) {
        setState(() {
          controller.play();
          controller.setLooping(true);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UploadController videoController = Get.put(UploadController());
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller)),
            _textField(
                controller: videoController.titleController,
                hintText: 'Enter a title'),
            _textField(
                controller: videoController.descController,
                hintText: 'Enter a description')
          ],
        )),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await videoController.uploadToStorage(widget.video!);
                  Get.off(() => const LandingScreen());
                },
                icon: const Icon(Icons.send))
          ],
          title: const Text("Create a new Reel"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Widget _textField(
    {required TextEditingController controller, required String hintText}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText, border: const OutlineInputBorder()),
    ),
  );
}
