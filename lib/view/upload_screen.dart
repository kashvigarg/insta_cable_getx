import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:insta_cable/helpers/video_picker_helper.dart';
import 'package:insta_cable/view/create_new_reel.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final videoFile = VideoPickerHelper.pickVideo();
              if (videoFile == null) return;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          CreateNewReelScreen(video: videoFile))));
            },
            backgroundColor: Colors.greenAccent,
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
          ),
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text("My Reels",
                  style: TextStyle(color: Colors.black)))),
    );
  }
}
