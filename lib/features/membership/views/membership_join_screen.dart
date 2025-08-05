import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/modals/loading_modal.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/membership/provider/get_future_membership.dart';

import 'package:read_quest/features/membership/repository/member_repository.dart';
import 'package:read_quest/router/route_name_enum.dart';

class MembershipJoinScreen extends ConsumerStatefulWidget {
  const MembershipJoinScreen({super.key});

  @override
  ConsumerState<MembershipJoinScreen> createState() =>
      _MembershipJoinScreenState();
}

class _MembershipJoinScreenState extends ConsumerState<MembershipJoinScreen> {
  void joinMembership(UserTypes userType) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Join Membership',
      desc: 'Do you want to join as $userType?',
      btnOkOnPress: () async {
        LoadingModal.showLoadingModal(context);
        final result = await ref
            .read(memberRepositoryProvider)
            .joinGroup(userType);
        LoadingModal.hideLoadingModal(context);
        if (result.isSuccess) {
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'You have successfully joined as ${userType.name}.',
          ).show();
          ref.refresh(getMembershipProvider);
          return;
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Error',
            desc: result.error,
          ).show();
        }
      },
      btnCancelOnPress: () => {},
      btnOkColor: AppColors.primary,
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
              //? Heading
              Text(
                'Join Your Account',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(size.height / 80),
              Text(
                "Please specify what type of account you want to create.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textLabel,
                ),
              ),

              Gap(size.height / 40),

              //? USER TYPE Buttons
              PrimaryButton(
                color: AppColors.secondary,
                label: 'Student',
                onPressed: () => joinMembership(UserTypes.student),
              ),
              Gap(size.height / 60),
              PrimaryButton(
                color: AppColors.tertiary,
                label: 'Teacher',
                onPressed: () => joinMembership(UserTypes.teacher),
              ),
              Gap(size.height / 60),
              PrimaryButton(
                color: AppColors.textLabel,
                label: 'Admin',
                onPressed: () => joinMembership(UserTypes.admin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
