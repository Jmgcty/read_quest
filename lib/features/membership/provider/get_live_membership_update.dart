import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/model/member_model.dart';
import 'package:read_quest/features/membership/repository/member_repository.dart';

final membershipStreamProvider = StreamProvider<MemberModel?>((ref) {
  final repo = ref.watch(memberRepositoryProvider);
  return repo.getMembershipByCurrentUser(); // This returns a Stream
});
