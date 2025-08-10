// ignore_for_file: unused_result

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/modals/loading_modal.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/auth/repository/auth_repository.dart';
import 'package:read_quest/features/home/views/home_screen.dart';
import 'package:read_quest/features/membership/provider/get_future_membership.dart';
import 'package:read_quest/features/membership/repository/member_repository.dart';
import 'package:read_quest/features/start/views/get_started_screen.dart';

class MembershipPendingScreen extends ConsumerStatefulWidget {
  const MembershipPendingScreen({super.key});

  @override
  ConsumerState<MembershipPendingScreen> createState() =>
      _MembershipPendingScreenState();
}

class _MembershipPendingScreenState
    extends ConsumerState<MembershipPendingScreen> {
  void checkStatus() async {
    if (!mounted) return;

    LoadingModal.showLoadingModal(context);

    final value = await ref.read(memberRepositoryProvider).getMembership();

    if (!mounted) return;

    LoadingModal.hideLoadingModal(context);

    if (!mounted) return;

    if (value?.status.name == MemberStatus.accepted.name) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Account Activation',
        desc: 'Your Account is Accepted',
      ).show();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (value?.status.name == MemberStatus.rejected.name) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Account Activation',
        desc: 'Your Account is Rejected',
      ).show();

      if (!mounted) return;

      ref.refresh(getMembershipProvider);
    } else {
      if (!mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.scale,
        title: 'Account Activation',
        desc: 'Your Account is Pending for Admin Approval',
      ).show();
    }
  }

  void logout() async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'Logout',
      desc: 'Are you sure you want to logout?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await ref.read(authRepositoryProvider).logout();
        if (!mounted) return;
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Logout Successfully',
          desc: 'You have successfully logged out.',
        ).show();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => GetStartedScreen()),
          (_) => false,
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.backgroundBlue),
          padding: EdgeInsets.symmetric(horizontal: size.width / 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Account is Pending',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(size.height / 40),
              Text(
                "Please wait for Admin's Approval to join your account",

                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textLabel,
                ),
              ),
              Gap(size.height / 40),
              PrimaryButton(label: 'Check Status', onPressed: checkStatus),
              Gap(size.height / 60),
              PrimaryButton(
                color: AppColors.textLabel,
                label: 'Logout',
                onPressed: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
