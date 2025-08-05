import 'package:appwrite/models.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? address;
  final String? phoneNumber;
  String? profileImage;
  DateTime? updatedAt;
  DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.profileImage,
    this.address,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['id'],
      email: map['email'],
      profileImage: map['profile'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phone'],
      createdAt: map['created_at']?.toDate(),
      updatedAt: map['updated_at']?.toDate(),
    );
  }

  factory UserModel.fromAppWrite(User user) {
    return UserModel(uid: user.$id, email: user.email, name: user.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': uid,
      'email': email,
      'profile': profileImage,
      'name': name,
      'address': address,
      'phone': phoneNumber,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? profileImage,
    String? name,
    String? address,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
