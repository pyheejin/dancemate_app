import 'package:dancemate_app/database/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final ApiServices api = ApiServices();

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
    final TextEditingController nicknameController = TextEditingController();
    final TextEditingController introductionController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 변경'),
      ),
      body: FutureBuilder(
        future: api.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String nickname = snapshot.data['nickname'];
            String introduction = snapshot.data['introduction'];
            String imageUrl = snapshot.data['image_url'];

            nicknameController.text = nickname;
            introductionController.text = introduction;

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: (imagePath != '')
                        ? CircleAvatar(
                            radius: 75,
                            foregroundImage: AssetImage(imagePath),
                            child: const Text('local'),
                          )
                        : Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(75),
                            ),
                            child: imageUrl == ''
                                ? const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  )
                                : imageUrl.split(':')[0] == 'https'
                                    ? CircleAvatar(
                                        radius: 50,
                                        foregroundImage: NetworkImage(imageUrl),
                                        child: Text(nickname),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        foregroundImage: AssetImage(imageUrl),
                                        child: const Text('local'),
                                      ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nicknameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: introductionController,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '자기소개',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFA48AFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          '저장',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
