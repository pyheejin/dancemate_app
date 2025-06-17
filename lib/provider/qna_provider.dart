import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getQnaProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getQnas();
  return result;
});

class QnaNotifier extends StateNotifier<dynamic> {
  QnaNotifier() : super([]);

  dynamic addQna(dynamic qna) async {
    final ApiServices api = ApiServices();

    final result = await api.postQna(qna);
    return result;
  }

  dynamic updateQna(int qnaId, dynamic qna) async {
    final ApiServices api = ApiServices();

    final result = await api.putQnaDetail(qnaId, qna);
    return result;
  }
}

final qnaProvider = StateNotifierProvider<QnaNotifier, dynamic>((ref) {
  return QnaNotifier();
});
