import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_colors.dart';

class MembershipRejectedScreen extends StatelessWidget {
  const MembershipRejectedScreen({super.key});

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
                'Account is Rejected',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(size.height / 40),
              Text(
                "Please check your Credentials and try again. Or contact your administrator.",

                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
