import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/constants/app_config.dart';
import 'package:insta_cable/model/video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controller/data_controller.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({super.key, required this.post});

  final VideoModel post;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  bool liked = false;
  bool isPressed = false;
  int count = 0;
  bool vol = true;

  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;
  final DataController dataController = Get.find();

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.post.videoUrl);
    _initializeVideoPlayerFuture = controller.initialize().then(
      (value) {
        if (mounted) {
          controller.setLooping(true);
          controller.play();
        } else
          controller.pause();
      },
    );
    // liked = dataController.isLiked(widget.post.videoUrl);
    count = widget.post.numLikes;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: safeHeight * 0.9,
            child: Card(
              child: Stack(alignment: Alignment.bottomCenter, children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VisibilityDetector(
                        key: Key(widget.post.videoUrl),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (info.visibleFraction == 0.5) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                        },
                        child: Listener(
                            onPointerDown: (event) {
                              setState(() {
                                isPressed = true;
                              });
                              controller.pause();
                            },
                            onPointerUp: (event) {
                              setState(() {
                                isPressed = false;
                              });
                              controller.play();
                            },
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    double ans = vol == true ? 0 : 50;
                                    controller.setVolume(ans);
                                    vol = !vol;
                                  });
                                },
                                child: VideoPlayer(controller)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      isPressed
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.post.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textScaleFactor: 1.6,
                                ),
                                Text(
                                  widget.post.description,
                                  textScaleFactor: 1.3,
                                ),
                              ],
                            ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              liked = !liked;
                            });
                            if (liked == true) {
                              count++;
                              dataController.like(widget.post.videoUrl);
                            } else {
                              count--;
                              dataController.like(widget.post.videoUrl);
                            }
                          },
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.thumb_up_sharp,
                                color:
                                    (liked == true) ? Colors.red : Colors.grey,
                              ),
                              Text(count.toString())
                            ],
                          ))
                    ],
                  ),
                )
              ]),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
