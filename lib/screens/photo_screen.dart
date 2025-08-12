import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatefulWidget {
  List<String> imagePathList;

  int currentIndex;

  PhotoScreen({
    super.key,
    required this.imagePathList,
    required this.currentIndex,
  });

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late PageController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = PageController(initialPage: widget.currentIndex);

    return Scaffold(
      body: PageView.builder(
          controller: _controller,
          itemCount: widget.imagePathList.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                PhotoView(
                  imageProvider: NetworkImage(widget.imagePathList[index]),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 45, right: 20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      "${index + 1} / ${widget.imagePathList.length}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
