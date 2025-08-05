import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/features/membership/provider/get_future_membership.dart';
import 'package:read_quest/features/membership/views/membership_join_screen.dart';
import 'package:read_quest/features/membership/views/membership_pending_screen.dart';
import 'package:read_quest/features/membership/views/membership_rejected_screen.dart';

// ignore: must_be_immutable
class MembershipScreen extends ConsumerStatefulWidget {
  MembershipScreen({super.key});

  final screens = [
    const MembershipJoinScreen(),
    const MembershipRejectedScreen(),
    const MembershipPendingScreen(),
  ];
  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  @override
  Widget build(BuildContext context) {
    final membership = ref.watch(getMembershipProvider);
    return membership.when(
      data: (data) {
        if (data?.status.name == MemberStatus.pending.name) {
          return widget.screens[2];
        } else if (data?.status.name == MemberStatus.rejected.name) {
          return widget.screens[1];
        } else {
          return widget.screens[0];
        }
      },
      error: (error, stackTrace) =>
          const Scaffold(body: Center(child: Text('Error'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
