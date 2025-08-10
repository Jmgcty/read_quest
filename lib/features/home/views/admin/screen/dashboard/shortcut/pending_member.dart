// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/model/member_model.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/core/utils/formatter.dart';
import 'package:read_quest/features/home/provider/get_realtime_pending_member.dart';
import 'package:read_quest/features/membership/repository/member_repository.dart';

class PendingMember extends ConsumerStatefulWidget {
  const PendingMember({super.key});

  @override
  ConsumerState<PendingMember> createState() => _PendingMemberState();
}

class _PendingMemberState extends ConsumerState<PendingMember> {
  @override
  void initState() {
    super.initState();
    ref.refresh(getRealtimePendingMemberProvider);
  }

  void acceptMember(MemberModel memberModel) async {
    final repo = ref.read(memberRepositoryProvider);

    memberModel = memberModel.copyWith(status: MemberStatus.accepted);
    final result = await repo.updateMemberStatus(memberModel);

    if (result.isSuccess) {
      ref.refresh(getRealtimePendingMemberProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member accepted successfully')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to accept member')));
    }
  }

  void rejectMember(MemberModel memberModel) async {
    final repo = ref.read(memberRepositoryProvider);

    memberModel = memberModel.copyWith(status: MemberStatus.rejected);
    final result = await repo.updateMemberStatus(memberModel);

    if (result.isSuccess) {
      ref.refresh(getRealtimePendingMemberProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member rejected successfully')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to reject member')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingMembers = ref.watch(getRealtimePendingMemberProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Membership'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: pendingMembers.when(
        data: (members) => members.isEmpty
            ? const NoPendingMember()
            : ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) => UserCard(
                  memberModel: members[index],
                  onView: () {},
                  onAccept: () => acceptMember(members[index]),
                  onReject: () => rejectMember(members[index]),
                ),
              ),
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    required this.memberModel,
    required this.onView,
    required this.onAccept,
    required this.onReject,
    super.key,
  });
  final MemberModel memberModel;
  final VoidCallback onView;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Card(
      child: ListTile(
        title: Text('${memberModel.user.name} (${memberModel.user.uid})'),
        subtitle: Text(
          formatStringToCapitalFirstLetter(memberModel.status.name),
          style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.warning),
        ),
        onTap: onView,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onAccept,
              color: Colors.green,
              icon: Icon(Icons.check, size: size.width / 12),
            ),
            Gap(size.width / 40),
            IconButton(
              onPressed: onReject,
              color: Colors.red,
              icon: Icon(Icons.cancel, size: size.width / 12),
            ),
          ],
        ),
      ),
    );
  }
}

class NoPendingMember extends StatelessWidget {
  const NoPendingMember({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No Pending Member'));
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.error, super.key});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}
