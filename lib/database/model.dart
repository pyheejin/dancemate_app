class UserModel {
  int? id;
  int type;
  int method;
  String email;
  String password;
  String nickname;
  String name;
  String phone;
  String introduction;
  String imageUrl;

  // 생성자
  UserModel({
    this.id,
    required this.type,
    required this.method,
    required this.email,
    required this.password,
    required this.nickname,
    required this.name,
    required this.phone,
    required this.introduction,
    required this.imageUrl,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'method': method,
      'email': email,
      'password': password,
      'nickname': nickname,
      'name': name,
      'phone': phone,
      'introduction': introduction,
      'image_url': imageUrl,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      type: json['type'],
      method: json['method'],
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      name: json['name'],
      phone: json['phone'],
      introduction: json['introduction'],
      imageUrl: json['image_url'],
    );
  }
}
