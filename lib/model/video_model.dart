import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// title, description, videoLink,
// //uid (user id of creator), nLikes (number of likes). And an option to like.

class VideoModel {
  final String title;
  final String description;
  final String videoLink;
  final String videoId;
  final String authorId;
  final int numLikes;
  // final Duration videoLength;
  final String? thumbnail;
  VideoModel({
    required this.title,
    required this.description,
    required this.videoLink,
    required this.videoId,
    required this.authorId,
    required this.numLikes,
    // required this.videoLength,
    this.thumbnail,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'videoLink': videoLink,
      'videoId': videoId,
      'authorId': authorId,
      'numLikes': numLikes,
      // 'videoLength': videoLength.toMap<String, dynamic>(),
      'thumbnail': thumbnail,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      title: map['title'] as String,
      description: map['description'] as String,
      videoLink: map['videoLink'] as String,
      videoId: map['videoId'] as String,
      authorId: map['authorId'] as String,
      numLikes: map['numLikes'] as int,
      // videoLength: Duration.fromMap(map['videoLength'] as Map<String,dynamic>),
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
