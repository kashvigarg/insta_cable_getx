import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:insta_cable/model/video_model.dart';

class DataController extends GetxController {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var db = FirebaseFirestore.instance;
  List<VideoModel> videos = <VideoModel>[].obs;

  int get length => videos.length;

  Future<void> likeToggle(String videoUrl, bool like) async {
    await db
        .collection("videos")
        .where("videoUrl", isEqualTo: videoUrl)
        .get()
        .then((value) {
      for (var docSnapshot in value.docs) {
        int curr = docSnapshot.data()['numLikes'];
        docSnapshot
            .data()
            .update('numLikes', (value) => like == true ? curr + 1 : curr - 1);
      }
    });
  }

  Future<List<VideoModel>> getVideos() async {
    await db.collection("videos").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        VideoModel vf = VideoModel(
            title: docSnapshot.data()['title'],
            description: docSnapshot.data()['description'],
            authorId: docSnapshot.data()['authorId'],
            numLikes: docSnapshot.data()['numLikes'],
            videoUrl: docSnapshot.data()['videoUrl']);
        videos.add(vf);
      }
    });
    return videos;
  }

  Future<List<VideoModel>> get() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("videos").get();
    final data = snapshot.docs.map((e) => VideoModel.fromFireStore(e)).toList();
    return data;
  }

  Future<List<VideoModel>> getUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("videos")
        .where("authorId", isEqualTo: uid)
        .get();
    final data = snapshot.docs.map((e) => VideoModel.fromFireStore(e)).toList();
    return data;
  }

  // FirebaseFirestore.instance.collection("videos").get().then(
  //     (querySnapshot) {
  //       print("Successfully completed");
  //       for (var docSnapshot in querySnapshot.docs) {
  //         print('${docSnapshot.id} => ${docSnapshot.data()}');
  //       }
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );
}
