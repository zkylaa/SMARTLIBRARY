// lib/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String studentId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['student_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'student_id': studentId,
      };
}