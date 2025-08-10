import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/membership/repository/member_repository.dart';

final allRealtimeAcceptedMemberProvider = StreamProvider(
  (ref) => ref.read(memberRepositoryProvider).getRealTimeAcceptedMembers(),
);
