import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// title, description, videoLink,
// //uid (user id of creator), nLikes (number of likes). And an option to like.

class VideoModel {
  final String title;
  final String description;
  final String authorId;
  final String videoUrl;
  final int numLikes;
  final String thumbnail;
  VideoModel(
      {required this.title,
      required this.description,
      required this.authorId,
      required this.numLikes,
      required this.videoUrl,
      required this.thumbnail});

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'authorId': authorId ?? "",
      'numLikes': numLikes,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail
    };
  }

  factory VideoModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data();
    return VideoModel(
        title: map?['title'] as String,
        description: map?['description'] as String,
        authorId: map?['authorId'] as String,
        numLikes: map?['numLikes'] as int,
        videoUrl: map?['videoUrl'] as String,
        thumbnail: map?['thumbnail'] as String);
  }
}
