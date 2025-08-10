import 'package:read_quest/core/model/user_model.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';

class MemberModel {
  final UserModel user;
  final UserTypes role;
  final MemberStatus status;
  final String? createdAt;
  final String? updatedAt;

  MemberModel({
    required this.user,
    required this.role,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  MemberModel copyWith({
    UserModel? user,
    UserTypes? role,
    MemberStatus? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return MemberModel(
      user: user ?? this.user,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      user: UserModel.fromMap(json['user']),
      role: UserTypes.getValue(json['role']),
      status: MemberStatus.getValue(json['status']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.uid,
      'role': role.name,
      'status': status.name,
    };
  }
}
