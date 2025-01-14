class RecommendUserModel {
  int? id;
  String email;
  String nickname;
  String imageUrl;

  // 생성자
  RecommendUserModel({
    this.id,
    required this.email,
    required this.nickname,
    required this.imageUrl,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'image_url': imageUrl,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory RecommendUserModel.fromJson(Map<String, dynamic> json) {
    return RecommendUserModel(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      imageUrl: json['image_url'],
    );
  }
}

class CourseModel {
  int? id;
  int userId;
  String title;
  String lastCourseDate;
  int count;
  String imageUrl;
  List<dynamic> courseDetail;
  Map<String, dynamic> dancer;

  // 생성자
  CourseModel({
    this.id,
    required this.userId,
    required this.title,
    required this.lastCourseDate,
    required this.count,
    required this.imageUrl,
    required this.courseDetail,
    required this.dancer,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'last_course_date': lastCourseDate,
      'count': count,
      'image_url': imageUrl,
      'course_detail': courseDetail,
      'dancer': dancer,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      lastCourseDate: json['last_course_date'],
      count: json['count'],
      imageUrl: json['image_url'],
      courseDetail: json['course_detail'],
      dancer: json['dancer'],
    );
  }
}

class UserModel {
  int? id;
  int type;
  String email;
  String password;
  String nickname;
  String name;
  String phone;
  String introduction;

  // 생성자
  UserModel({
    this.id,
    required this.type,
    required this.email,
    required this.password,
    required this.nickname,
    required this.name,
    required this.phone,
    required this.introduction,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'email': email,
      'password': password,
      'nickname': nickname,
      'name': name,
      'phone': phone,
      'introduction': introduction,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      type: json['type'],
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      name: json['name'],
      phone: json['phone'],
      introduction: json['introduction'],
    );
  }
}
