import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/model/video_model.dart';
import 'package:video_player/video_player.dart';

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

class FullPostView extends StatelessWidget {
  const FullPostView({super.key, required this.post});

  final VideoModel post;
  @override
  Widget build(BuildContext context) {
    final VideoPlayerController _controller = VideoPlayerController.contentUri(
        Uri.parse(post.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true));
    return Card(
      child: Column(
        children: [
          Text(post.title),
          VideoPlayer(_controller),
          Text(post.description),
          IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  Icon(Icons.heart_broken),
                  Text(post.numLikes.toString())
                ],
              ))
        ],
      ),
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
        post.videoUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

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
