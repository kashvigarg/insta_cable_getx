import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_cable/controller/auth_controller.dart';
import 'package:insta_cable/helpers/video_picker_helper.dart';
import 'package:insta_cable/model/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoController extends GetxController {
  // video details dependencies
  final titleController = TextEditingController();
  final descController = TextEditingController();
  static final _videoPicker = ImagePicker();

  // controller dependencies
  final AuthController authController = Get.find();

  // firebase dependencies
  final posts = FirebaseFirestore.instance.collection("videos").obs();

  // variables
  List<VideoModel> videos = <VideoModel>[].obs;
  List<VideoModel> userVideos = <VideoModel>[].obs;
  File? file;

  Future<File?> pickVideo() async {
    file = await _videoPicker.pickVideo(source: ImageSource.gallery).toFile();
    return file;
  }

  uploadToStorage(File file) async {
    final uid = authController.firebaseUser.value!.uid;

    try {
      final metadata = SettableMetadata(contentType: 'video/mp4');
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = storageRef
          .child("videos/user/$uid/${file.path}")
          .putFile(file, metadata);
      final downloadUrl = await storageRef
          .child("videos/user/$uid/${file.path}")
          .getDownloadURL();
      // final vidRef =
      //     storageRef.child(uid).child(DateTime.now().toIso8601String());

      // vidRef.getDownloadURL().then((value) => {downloadUrl = value});

      final VideoModel videoF = VideoModel(
        title: titleController.value.text,
        description: descController.value.text,
        authorId: uid,
        videoUrl: downloadUrl,
        numLikes: 0,
      );

      uploadData(videoF);
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadData(VideoModel video) async {
    await FirebaseFirestore.instance
        .collection("videos")
        .add(video.ToFirestore());
  }

  // fetchVideos() async {
  //   return FirebaseFirestore.instance.collection("videos").get();
  // }

  // Future<int> totalVideos() async {
  //   var vids = await FirebaseFirestore.instance
  //       .collection("videos")
  //       .doc()
  //       .snapshots()
  //       .length;
  //   return vids;
  // }

  // getAllVideos() async {
  //   final storageRef =
  //       FirebaseStorage.instance.ref().child('videos').child('all');
  //   final list = await storageRef.listAll();
  //   final uid = authController.firebaseUser.value!.uid;

  //   for (var item in list.items) {
  //     String downloadUrl = await item.getDownloadURL();
  //     final VideoModel videoF = VideoModel(
  //       title: titleController.value.text,
  //       description: descController.value.text,
  //       authorId: uid ?? '',
  //       videoUrl: downloadUrl,
  //       numLikes: 0,
  //     );
  //     videos.add(videoF);
  //   }
  // }

  // getUserVideos() async {
  //   final uid = authController.firebaseUser.value!.uid;
  //   final storageRef = FirebaseStorage.instance.ref().child('videos/user/$uid');
  //   final list = await storageRef.listAll();

  //   for (var item in list.items) {
  //     String downloadUrl = await item.getDownloadURL();
  //     final VideoModel videoF = VideoModel(
  //       title: titleController.value.text,
  //       description: descController.value.text,
  //       authorId: uid ?? '',
  //       videoUrl: downloadUrl,
  //       numLikes: 0,
  //     );
  //     userVideos.add(videoF);
  //   }
  // }
}
