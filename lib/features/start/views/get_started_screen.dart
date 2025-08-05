import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_assets.dart';
import 'package:read_quest/core/services/pref_storage.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/auth/repository/auth_repository.dart';
import 'package:read_quest/features/auth/views/login_screen.dart';
import 'package:read_quest/features/home/views/home_screen.dart';
import 'package:read_quest/features/membership/repository/member_repository.dart';
import 'package:read_quest/features/membership/views/membership_screen.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  GetStartedScreen({super.key});
  bool isButtonHide = true;
  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    final user = await ref.read(authRepositoryProvider).getCurrentUser();
    if (user != null) {
      final membership = await ref
          .read(memberRepositoryProvider)
          .getMembership();
      if (membership?.status.name == MemberStatus.accepted.name) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => MembershipScreen()),
        );
      }
      return;
    }
    await SharedPrefStorage.instance.removeAuthSession();
    setState(() {
      widget.isButtonHide = false;
    });
  }

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
              if (!widget.isButtonHide)
                PrimaryButton(
                  label: 'Get Started',
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
