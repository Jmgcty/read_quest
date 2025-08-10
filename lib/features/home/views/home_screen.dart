import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/features/auth/repository/auth_repository.dart';
import 'package:read_quest/features/home/views/admin/admin_screen.dart';
import 'package:read_quest/features/home/views/reader/reader_screen.dart';
import 'package:read_quest/features/home/views/teacher/teacher_screen.dart';
import 'package:read_quest/features/membership/provider/get_future_membership.dart';
import 'package:read_quest/features/membership/repository/member_repository.dart';
import 'package:read_quest/features/membership/views/membership_pending_screen.dart';
import 'package:read_quest/features/membership/views/membership_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  //
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  void init() async {
    final member = await ref.read(memberRepositoryProvider).getMembership();
    if (member?.status.name == MemberStatus.pending.name) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => MembershipScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = ref.watch(getMembershipProvider);

    return member.when(
      data: (data) {
        if (data?.role.name == UserTypes.admin.name) {
          return AdminScreen();
        } else if (data?.role.name == UserTypes.teacher.name) {
          return const TeacherScreen();
        } else {
          return const ReaderScreen();
        }
      },
      error: (error, stackTrace) => ErrorScreen(),
      loading: () => LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Error: Check Internet')));
  }
}
