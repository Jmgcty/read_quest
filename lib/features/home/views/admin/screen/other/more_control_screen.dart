import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/features/auth/repository/auth_repository.dart';
import 'package:read_quest/features/home/views/admin/provider/page_provider.dart';
import 'package:read_quest/features/start/views/get_started_screen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
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
        ref.read(adminPageProvider.notifier).resetPage();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemTile(title: 'Profile', icon: Icons.person, onTap: () {}),
        ItemTile(title: 'Change Password', icon: Icons.lock, onTap: () {}),
        ItemTile(title: 'Settings', icon: Icons.settings, onTap: () {}),
        ItemTile(title: 'Logout', icon: Icons.logout, onTap: logout),
      ],
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      tileColor: AppColors.white,
    );
  }
}
