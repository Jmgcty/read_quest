enum UserTypes {
  student,
  teacher,
  admin;

  static UserTypes getValue(String value) {
    switch (value) {
      case 'student':
        return UserTypes.student;
      case 'teacher':
        return UserTypes.teacher;
      case 'admin':
        return UserTypes.admin;
      default:
        return UserTypes.student;
    }
  }
}
