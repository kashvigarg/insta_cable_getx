import 'package:flutter/material.dart';
import 'package:insta_cable/model/video_model.dart';

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
