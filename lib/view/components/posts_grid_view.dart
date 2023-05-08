import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/helpers/show_snackbar.dart';
import 'package:insta_cable/model/video_model.dart';
import 'package:insta_cable/view/components/post_thumbnail_view.dart';

import 'full_post_view.dart';

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
              showSnackbar(
                  msg: "Error Occurred", submsg: snapshot.error.toString());
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(child: Text("Please try again later :("));
        });
  }
}
