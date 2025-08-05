enum UserTypes {
  student,
  teacher,
  admin,
  none;

  static UserTypes getValue(String value) {
    switch (value) {
      case 'student':
        return UserTypes.student;
      case 'teacher':
        return UserTypes.teacher;
      case 'admin':
        return UserTypes.admin;
      default:
        return UserTypes.none;
    }
  }
}

enum MemberStatus {
  pending,
  accepted,
  rejected,
  none;

  static MemberStatus getValue(String value) {
    switch (value) {
      case 'pending':
        return MemberStatus.pending;
      case 'accepted':
        return MemberStatus.accepted;
      case 'rejected':
        return MemberStatus.rejected;
      default:
        return MemberStatus.none;
    }
  }
}
