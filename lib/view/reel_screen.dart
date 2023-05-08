import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_cable/controller/data_controller.dart';
import 'package:insta_cable/extensions/list_difference.dart';
import 'package:insta_cable/helpers/show_snackbar.dart';
import 'package:insta_cable/model/video_model.dart';

import 'components/full_post_view.dart';

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
              // List<VideoModel> data = [];
              // for (int i = 0; i < temp.length; i++) {
              //   if (i > 9) break;
              //   data.add(temp[i]);
              // }
              // temp = temp.whereNotIn(data).toList();
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    if (index % 9 == 0) {
                      //   for (int i = 0; i < 10; i++) {
                      //     data.add(temp[i]);
                      //   }
                      showSnackbar(msg: "Making API call", submsg: "");
                    }
                    return FullPostView(post: data.elementAt(index));
                  }));
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
        }));
  }
}
