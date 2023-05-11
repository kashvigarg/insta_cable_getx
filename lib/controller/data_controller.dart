import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:insta_cable/model/video_model.dart';

class DataController extends GetxController {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var db = FirebaseFirestore.instance;
  List<DocumentSnapshot<Object?>> videos = <DocumentSnapshot<Object?>>[].obs;

  int get length => videos.length;

  isLiked(String videoUrl) async {
    bool val = false;
    await db
        .collection("videos")
        .where("videoUrl", isEqualTo: videoUrl)
        .get()
        .then((value) {
      for (var q in value.docs) {
        val = q.data()['isLiked'];
      }
      return val;
    });
  }

  getLikes(String videoUrl) async {
    int curr = 0;
    await db
        .collection("videos")
        .where("videoUrl", isEqualTo: videoUrl)
        .get()
        .then((value) {
      for (var docSnapshot in value.docs) {
        curr = docSnapshot.data()['numLikes'];
      }
      return curr;
    });
  }

  Future<void> like(String videoUrl) async {
    await db
        .collection("videos")
        .where("videoUrl", isEqualTo: videoUrl)
        .get()
        .then((value) {
      for (var docSnapshot in value.docs) {
        int curr = docSnapshot.data()['numLikes'];
        docSnapshot.data().update('numLikes', (value) => curr + 1);
        docSnapshot.data().update('isLiked', (value) => true);
      }
    });
  }

  Future<void> unlike(String videoUrl) async {
    await db
        .collection("videos")
        .where("videoUrl", isEqualTo: videoUrl)
        .get()
        .then((value) {
      for (var docSnapshot in value.docs) {
        int curr = docSnapshot.data()['numLikes'];
        docSnapshot.data().update('numLikes', (value) => curr - 1);
      }
    });
  }

  Future<List<VideoModel>> getNext10() async {
    int len = videos.length;
    var lastFetch = videos[len - 1];
    var snapshot = await db
        .collection("videos")
        .startAfterDocument(lastFetch)
        .limit(10)
        .get();
    var data = snapshot.docs.map((e) => VideoModel.fromFireStore(e)).toList();
    return data;
  }
  // Future<List<VideoModel>> getVideos() async {
  //   await db.collection("videos").get().then((querySnapshot) {
  //     for (var docSnapshot in querySnapshot.docs) {
  //       VideoModel vf = VideoModel(
  //           thumbnail:
  //               "https://img.republicworld.com/republic-prod/stories/promolarge/xhdpi/b1mfd6svjbn9a1tg_1598679873.jpeg",
  //           title: docSnapshot.data()['title'],
  //           description: docSnapshot.data()['description'],
  //           authorId: docSnapshot.data()['authorId'],
  //           isLiked: docSnapshot.data()['isLiked'],
  //           numLikes: docSnapshot.data()['numLikes'],
  //           videoUrl: docSnapshot.data()['videoUrl']);
  //       videos.add(vf);
  //     }
  //   });
  //   return videos;
  // }

  Future<List<VideoModel>> getFirst10() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("videos").limit(10).get();
    final data = snapshot.docs.map((e) => VideoModel.fromFireStore(e)).toList();
    videos = snapshot.docs;
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
}
