import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/router/route_name_enum.dart';

class MembershipJoinScreen extends StatefulWidget {
  const MembershipJoinScreen({super.key});

  @override
  State<MembershipJoinScreen> createState() => _MembershipJoinScreenState();
}

class _MembershipJoinScreenState extends State<MembershipJoinScreen> {
  void joinMembership(String userType) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Join Membership',
      desc: 'Do you want to join as $userType?',
      btnOkOnPress: () {
        context.goNamed(RouteName.membership.name, extra: 'pending');
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
                onPressed: () => joinMembership('Student'),
              ),
              Gap(size.height / 60),
              PrimaryButton(
                color: AppColors.tertiary,
                label: 'Teacher',
                onPressed: () => joinMembership('Teacher'),
              ),
              Gap(size.height / 60),
              PrimaryButton(
                color: AppColors.textLabel,
                label: 'Admin',
                onPressed: () => joinMembership('Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
