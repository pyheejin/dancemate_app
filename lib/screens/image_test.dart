import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageTest extends StatefulWidget {
  const ImageTest({super.key});

  @override
  State<ImageTest> createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  XFile? file;

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          file = image;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final length = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
        actions: [
          IconButton(onPressed: _pickImage, icon: const Icon(Icons.image))
        ],
      ),
      body: Center(
          child: Container(
        color: Colors.grey,
        height: length,
        width: length,
        child: (file != null)
            ? Image.file(
                File(file!.path),
                fit: BoxFit.cover,
              )
            : const Icon(
                Icons.image,
                size: 50,
                color: Colors.white,
              ),
      )),
    );
  }
}
