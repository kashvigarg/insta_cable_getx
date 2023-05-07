import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// title, description, videoLink,
// //uid (user id of creator), nLikes (number of likes). And an option to like.

class VideoModel {
  final String title;
  // final File videoFile;
  final String description;
  // final String videoLink;
  final String authorId;
  final String videoUrl;
  final int numLikes;
  // final Duration videoLength;
  // final String? thumbnail;
  VideoModel({
    required this.title,
    required this.description,
    // required this.videoLink,
    // required this.videoId,
    // required this.videoFile,
    required this.authorId,
    required this.numLikes,
    required this.videoUrl,
    // required this.videoLength,
    // this.thumbnail,
  });

  Map<String, dynamic> ToFirestore() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      // 'videoFile': videoFile,
      if (authorId != null) 'authorId': authorId,
      if (numLikes != null) 'numLikes': numLikes,
      if (videoUrl != null) 'videoUrl': videoUrl,
      // 'videoLength': videoLength.toMap<String, dynamic>(),
      // if (thumbnail!=null) 'thumbnail': thumbnail,
    };
  }

  factory VideoModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data();
    return VideoModel(
      title: map?['title'] as String,
      description: map?['description'] as String,
      // videoFile: map['videoFile'] as File,
      authorId: map?['authorId'] as String,
      numLikes: map?['numLikes'] as int,
      videoUrl: map?['videoUrl'] as String,
      // videoLength: Duration.fromMap(map['videoLength'] as Map<String,dynamic>),
      // thumbnail: map?['thumbnail'] != null ? map['thumbnail'] as String : null,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory VideoModel.fromJson(String source) =>
  //     VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
