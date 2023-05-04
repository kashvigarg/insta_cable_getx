import 'dart:io';
import 'package:flutter/material.dart';

class CreateNewReelScreen extends StatelessWidget {
  const CreateNewReelScreen({super.key, required this.video});

  final Future<File?> video;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Thumbnail View"),
              _textField(
                  controller: titleController, hintText: 'Enter a title'),
              _textField(
                  controller: descController, hintText: 'Enter a description')
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  // upload
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.send))
          ],
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text("Create a new Reel"),
        ),
      ),
    );
  }
}

Widget _textField(
    {required TextEditingController controller, required String hintText}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText, border: const OutlineInputBorder()),
    ),
  );
}
