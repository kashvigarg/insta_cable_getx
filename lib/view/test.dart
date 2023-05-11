import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_cable/helpers/show_snackbar.dart';
import 'package:insta_cable/view/components/full_post_view.dart';

import '../model/video_model.dart';

class TestP extends StatefulWidget {
  const TestP({super.key});

  @override
  _TestPState createState() => _TestPState();
}

class _TestPState extends State<TestP> {
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getDocuments();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scroll at top');
        else {
          print('ListView scroll at bottom');
          getDocumentsNext(); // Load next documents
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: listDocument.length != 0
            ? RefreshIndicator(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: listDocument.length,
                  itemBuilder: (context, index) {
                    return FullPostView(post: data.elementAt(index));
                  },
                ),
                onRefresh: getDocuments, // Refresh entire list
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  List<DocObj> listDocument = [];
  List<VideoModel> data = [];
  late QuerySnapshot collectionState;
  // Fetch first 15 documents
  Future<void> getDocuments() async {
    listDocument = [];
    var collection = FirebaseFirestore.instance.collection('videos').limit(5);
    print('getDocuments');
    fetchDocuments(collection);
  }

  // Fetch next 5 documents starting from the last document fetched earlier
  Future<void> getDocumentsNext() async {
    // Get the last visible document
    var lastVisible = collectionState.docs[collectionState.docs.length - 1];
    print('listDocument legnth: ${collectionState.size} last: $lastVisible');
    showSnackbar(msg: "Making API Call", submsg: " ");

    var collection = FirebaseFirestore.instance
        .collection('videos')
        .startAfterDocument(lastVisible)
        .limit(5);

    fetchDocuments(collection);
  }

  fetchDocuments(Query collection) {
    collection.get().then((value) {
      collectionState =
          value; // store collection state to set where to start next
      value.docs.forEach((element) {
        print('getDocuments ${element.data()}');
        setState(() {
          listDocument.add(DocObj(DocObj.setDocDetails(element.data() as Map)));
        });
      });
      data += value.docs
          .map((e) => VideoModel.fromFireStore(
              e as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }
}

class DocObj {
  var documentName;

  DocObj(DocObj doc) {
    this.documentName = doc.getDocName();
  }

  dynamic getDocName() => documentName;

  DocObj.setDocDetails(Map<dynamic, dynamic> doc) : documentName = doc['name'];
}
