import 'dart:async';
import 'dart:convert';
import 'package:dancemate_app/provider/image_provider.dart';
import 'package:dancemate_app/provider/setting_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dancemate_app/contants/contants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  // 위젯이 생성될 때 한 번만 호출되도록 initState 사용
  @override
  void initState() {
    super.initState();
    isloginData();
  }

  Future<void> isloginData() async {
    const storage = FlutterSecureStorage();
    String? data = await storage.read(key: 'login');
    if (data != null) {
      int type = json.decode(data)['userType'];
      ref
          .read(accessTokenProvider.notifier)
          .update((state) => json.decode(data)['access_token']);

      if (type == 50) {
        ref.read(isDancerProvider.notifier).update((state) => true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(getUserProfileProvider);
    String imagePath = ref.watch(profileImagePathProvider);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController =
        TextEditingController(text: '************');
    final TextEditingController nicknameController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController introductionController =
        TextEditingController();

    UserType userType = UserType.Mate;

    void onClearTap(TextEditingController controller) {
      controller.clear();
    }

    Future<void> pickCameraImage() async {
      Permission permission = Permission.camera;
      final status = await permission.request();
      print(status);

      if (status == PermissionStatus.granted) {
        ImagePicker imagePicker = ImagePicker();
        final image = await imagePicker.pickImage(source: ImageSource.camera);
        if (image != null) {
          ref
              .read(profileImagePathProvider.notifier)
              .update((state) => image.path);

          // 파일 경로를 통해 formData 생성
          FormData bodyData = FormData.fromMap({
            'bucket': 'profile',
            'images': MultipartFile.fromFileSync(image.path),
          });

          final result =
              await ref.watch(postImageUploadProvider(bodyData).future);
          final response = jsonDecode(result.toString());
          if (response['result_code'] == 200) {
            Navigator.pop(context);
            ref.refresh(getUserProfileProvider);
          } else {
            errorAlert(context, response['result_msg']);
          }
        }
      }
    }

    Future<void> pickImage() async {
      ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        ref
            .read(profileImagePathProvider.notifier)
            .update((state) => image.path);

        // 파일 경로를 통해 formData 생성
        FormData bodyData = FormData.fromMap({
          'bucket': 'profile',
          'images': MultipartFile.fromFileSync(image.path),
        });

        final result =
            await ref.watch(postImageUploadProvider(bodyData).future);
        final response = jsonDecode(result.toString());
        if (response['result_code'] == 200) {
          Navigator.pop(context);
          ref.refresh(getUserProfileProvider);
        } else {
          errorAlert(context, response['result_msg']);
        }
      }
    }

    Future<void> onProfileImageTap() async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200, // 모달 높이 크기
            decoration: const BoxDecoration(
              color: Colors.white, // 모달 배경색
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: pickCameraImage,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '사진 찍기',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: pickImage,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.photo_library_outlined,
                            size: 40,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '갤러리에서 선택',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    void onSaveTap() async {
      final nickname = nicknameController.text;
      final name = nameController.text;
      final phone = phoneController.text;
      final introduction = introductionController.text;

      // final result = await ref.watch(postUserJoinProvider(userData).future);
      // if (result['result_code'] == 200) {
      //   Navigator.of(context).pop();
      // } else {
      //   errorAlert(context, result['result_msg']);
      // }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: userProfile.when(
        data: (dataList) {
          final email = dataList['email'];
          final imageUrl = dataList['image_url'];
          final name = dataList['name'] ?? '';
          final nickname = dataList['nickname'];
          final introduction = dataList['introduction'];

          emailController.text = email;
          nicknameController.text = nickname;
          nameController.text = name;
          introductionController.text = introduction;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onProfileImageTap,
                        child: Container(
                          child: imageUrl != null
                              ? imageUrl == ''
                                  ? imagePath != ''
                                      ? CircleAvatar(
                                          radius: 50,
                                          foregroundImage:
                                              AssetImage(imagePath),
                                          child: Text(nickname),
                                        )
                                      : const CircleAvatar(
                                          radius: 50,
                                          foregroundImage: AssetImage(
                                              'assets/images/app_logo/chat.png'),
                                        )
                                  : imagePath != ''
                                      ? CircleAvatar(
                                          radius: 50,
                                          foregroundImage:
                                              AssetImage(imagePath),
                                          child: Text(nickname),
                                        )
                                      : imageUrl.split(':')[0] == 'https'
                                          ? CircleAvatar(
                                              radius: 50,
                                              foregroundImage:
                                                  NetworkImage(imageUrl),
                                              child: Text(nickname),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              foregroundImage:
                                                  AssetImage(imageUrl),
                                              child: Text(nickname),
                                            )
                              : const CircleAvatar(
                                  radius: 50,
                                  foregroundImage: AssetImage(
                                      'assets/images/app_logo/chat.png'),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: UserType.Dancer,
                            groupValue: userType,
                            onChanged: (UserType? value) {
                              userType =
                                  ref.watch(userTypeProvider(UserType.Dancer));
                            },
                          ),
                          const Text(
                            '댄서',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: UserType.Mate,
                            groupValue: userType,
                            onChanged: (UserType? value) {
                              userType =
                                  ref.watch(userTypeProvider(UserType.Mate));
                            },
                          ),
                          const Text(
                            '메이트',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '이메일',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      enabled: false,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '닉네임',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            onClearTap(nicknameController);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '이름',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: '',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            onClearTap(nameController);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '본인인증',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: '핸드폰 번호(숫자만 입력)',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            onClearTap(phoneController);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '인증번호',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            suffixIcon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFA48AFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '인증번호 전송',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        '자기소개',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 200,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: introductionController,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) {
          print(error);
          return SizedBox(
            width: 300,
            child: Text('error: $error'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: onSaveTap,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFA48AFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '저장',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
