import 'package:dancemate_app/database/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postImageUploadProvider =
    FutureProvider.family<dynamic, FormData>((ref, bodyData) async {
  final ApiServices api = ApiServices();

  final result = await api.postImageUpload(bodyData);
  return result;
});
