import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/constants/app_config.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/model/video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsGridView extends StatelessWidget {
  const PostsGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find();
    return FutureBuilder(
        future: dataController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<VideoModel> data = snapshot.data as List<VideoModel>;
              return data.isEmpty
                  ? const Center(
                      child: Text('No posts yet :('),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data.elementAt(index);
                        return PostThumbnailView(
                          post: post,
                          onTapped: () {
                            Get.to(FullPostView(post: post));
                          },
                        );
                      },
                    );
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Text(snapshot.connectionState.toString());
        });
  }
}

class FullPostView extends StatefulWidget {
  const FullPostView({super.key, required this.post});

  final VideoModel post;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  bool liked = false;
  bool isPressed = false;

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
                child: Card(
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Center(
                      child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller)),
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
                                dataController.likeToggle(
                                    widget.post.videoUrl, liked);
                              },
                              icon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.thumb_up_sharp,
                                    color: (liked == true)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  Text(
                                    widget.post.numLikes.toString(),
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PostThumbnailView extends StatelessWidget {
  final VideoModel post;
  final VoidCallback onTapped;
  const PostThumbnailView({
    Key? key,
    required this.post,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Image.network(
        post.thumbnail,
        fit: BoxFit.cover,
      ),
    );
  }
}

// child: Card(
//         child: Stack(alignment: Alignment.bottomCenter, children: [
//           // VideoPlayer(controller),
//           SizedBox(
//             height: safeHeight * 0.9,
//             // color: Colors.green,
//             child: VideoPlayer(controller),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.post.title,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                       textScaleFactor: 1.6,
//                     ),
//                     Text(
//                       widget.post.description,
//                       textScaleFactor: 1.3,
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                     alignment: Alignment.bottomRight,
//                     onPressed: () {
//                       setState(() {
//                         liked = !liked;
//                       });
//                       final DataController dataController = Get.find();
//                       bool ans = liked == true ? true : false;
//                       dataController.likeToggle(widget.post.videoUrl, ans);
//                     },
//                     icon: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         const Icon(
//                           Icons.thumb_up_sharp,
//                           color: Colors.red,
//                         ),
//                         Text(widget.post.numLikes.toString())
//                       ],
//                     ))
//               ],
//             ),
//           )
//         ]),
//       ),
// class PostVideoView extends HookWidget {
//   final Post post;

//   const PostVideoView({
//     Key? key,
//     required this.post,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = VideoPlayerController.network(
//       post.fileUrl,
//     );

//     final isVideoPlayerReady = useState(false);

//     useEffect(() {
//       controller.initialize().then(
//         (value) {
//           isVideoPlayerReady.value = true;
//           controller.setLooping(true);
//           controller.play();
//         },
//       );
//       return controller.dispose;
//     }, [controller]);

//     switch (isVideoPlayerReady.value) {
//       case true:
//         return AspectRatio(
//           aspectRatio: post.aspectRatio,
//           child: VideoPlayer(controller),
//         );
//       case false:
//         return const LoadingAnimationView();
//       default:
//         return const ErrorAnimationView();
//     }
//   }
// }
