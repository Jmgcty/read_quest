import 'package:flutter/material.dart';
import 'package:read_quest/features/membership/views/membership_join_screen.dart';
import 'package:read_quest/features/membership/views/membership_pending_screen.dart';

// ignore: must_be_immutable
class MembershipScreen extends StatelessWidget {
  MembershipScreen({this.status, super.key});

  String? status;
  @override
  Widget build(BuildContext context) {
    return status == 'pending'
        ? const MembershipPendingScreen()
        : MembershipJoinScreen();
  }
}
