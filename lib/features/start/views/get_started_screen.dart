import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_assets.dart';
import 'package:read_quest/core/widgets/primary_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width / 16),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.appBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.birdCartoon,
                scale: size.width / 140,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              Image.asset(
                AppAssets.appName,
                scale: size.width / 180,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              Gap(size.height / 20),
              PrimaryButton(label: 'Get Started', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
