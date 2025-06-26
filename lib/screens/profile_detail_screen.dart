import 'dart:convert';

import 'package:dancemate_app/database/api.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailScreen extends StatefulWidget {
  final WidgetRef ref;

  const ProfileDetailScreen({
    super.key,
    required this.ref,
  });

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

  void onSaveTap(FormData bodyData) async {
    final result = await api.postUserProfile(bodyData);
    if (jsonDecode(result.toString())['result_code'] == 200) {
      widget.ref.refresh(getUserProfileProvider);
      Navigator.pop(context);
    }
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
                        onPressed: () async {
                          // 파일 경로를 통해 formData 생성
                          FormData bodyData = FormData.fromMap({
                            'nickname': nicknameController.text,
                            'introduction': introductionController.text,
                          });

                          if (imagePath != '') {
                            bodyData = FormData.fromMap({
                              'nickname': nicknameController.text,
                              'introduction': introductionController.text,
                              'image_url':
                                  await MultipartFile.fromFile(imagePath),
                            });
                          }

                          onSaveTap(bodyData);
                        },
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
