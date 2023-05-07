import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/controller/video_controller.dart';
import 'package:insta_cable/helpers/posts_grid_view.dart';
import 'package:insta_cable/model/video_model.dart';
import 'package:video_player/video_player.dart';

class ReelScreen extends StatelessWidget {
  const ReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.put(DataController());
    return FutureBuilder(
        future: dataController.get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<VideoModel> data = snapshot.data as List<VideoModel>;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    return FullPostView(post: data.elementAt(index));
                  }));
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Text(snapshot.connectionState.toString());
        }));
  }
}
// class ReelScreen extends StatelessWidget {
//   const ReelScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     // final VideoController videoController = Get.find();
//     // videoController.getAllVideos();
//     // final videos = videoController.videos;
//     late List videos = [];
//     List<Widget> getVideos(AsyncSnapshot snapshot) {
//       return snapshot.data.docs.map((doc) {
//         return FullPostView(
//             post: VideoModel(
//                 title: doc,
//                 // title: (doc.data() as dynamic)['title'],
//                 description: (doc.data() as dynamic)['description'],
//                 authorId: (doc.data() as dynamic)['authorId'],
//                 numLikes: (doc.data() as dynamic)['numLikes'],
//                 vidUrl: (doc.data() as dynamic)['vidUrl']));
//       }).toList();
//       // print(videos[0]['title']);
//     }

//     return SafeArea(
//         child: Scaffold(
//       body: FutureBuilder(
//           future: FirebaseFirestore.instance.collection("videos").get(),
//           builder: ((context, snapshot) {
//             // if (snapshot.connectionState == ConnectionState.done)
//             return ListView(children: getVideos(snapshot));
//           })),
//     ));
//   }
// }

// class VideoView extends StatelessWidget {
//   const VideoView({super.key, required this.video});
//   final Map<String, dynamic> video;
//   @override
//   Widget build(BuildContext context) {
//     final VideoPlayerController controller =
//         VideoPlayerController.contentUri(Uri.parse(video['vidUrl']));
//     return Stack(
//       children: [
//         Icon(Icons.h_mobiledata)
//         // VideoPlayer(controller),
//         // Row(
//         //   children: [
//         //     Column(
//         //       children: [Text(video['title']), Text(video['description'])],
//         //     ),
//         //     IconButton(onPressed: () {}, icon: Icon(Icons.heart_broken))
//         //   ],
//         // )
//       ],
//     );
//   }
// }
