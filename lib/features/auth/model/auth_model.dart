class AuthModel {
  final String uid;
  final String password;
  final String? confirmPassword;
  AuthModel({required this.uid, required this.password, this.confirmPassword});

  AuthModel copyWith({String? uid, String? password, String? confirmPassword}) {
    return AuthModel(
      uid: uid ?? this.uid,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
