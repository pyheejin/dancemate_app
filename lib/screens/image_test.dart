import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageTest extends StatefulWidget {
  const ImageTest({super.key});

  @override
  State<ImageTest> createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  String imagePath = '';

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          imagePath = image.path;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const length = 200.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: GestureDetector(
        onTap: _pickImage,
        child: Center(
          child: SizedBox(
            height: length,
            width: length,
            child: (imagePath != '')
                ? CircleAvatar(
                    radius: 50,
                    foregroundImage: AssetImage(imagePath),
                  )
                : const Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
