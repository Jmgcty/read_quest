import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/book_management/book_table.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/user_management/user_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryCardPadding = EdgeInsets.symmetric(
      horizontal: size.width / 16,
    );

    //
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: size.height / 30),
        child: Column(
          children: [
            ShortCuts(),
            Gap(size.height / 40),
            Line(),
            Gap(size.height / 40),
            DashboardItems(
              icon: const Icon(Icons.person_pin_rounded),
              title: 'Manage Users',
              backgroundColor: AppColors.secondary,
              padding: primaryCardPadding,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => UsersTableScreen()),
                );
              },
            ),
            Gap(size.height / 60),
            DashboardItems(
              icon: const Icon(Icons.book),
              title: 'Manage Books',
              backgroundColor: AppColors.primary,
              padding: primaryCardPadding,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => BooksTableScreen()),
                );
              },
            ),
            Gap(size.height / 60),
            DashboardItems(
              icon: const Icon(Icons.games),
              title: 'Manage Games',
              backgroundColor: AppColors.tertiary,
              padding: primaryCardPadding,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItems extends StatelessWidget {
  const DashboardItems({
    required this.icon,
    required this.title,
    this.backgroundColor,
    this.padding,
    this.onTap,
    super.key,
  });

  final Icon icon;
  final String title;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(size.width / 18),
          width: size.width,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.primary,
            borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon.icon, size: size.width / 8, color: AppColors.white),
              Gap(size.height / 60),
              Text(
                title,
                style: theme.textTheme.titleLarge!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShortCuts extends StatelessWidget {
  const ShortCuts({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height / 10,
      child: GridView(
        padding: EdgeInsets.symmetric(horizontal: size.width / 16),

        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: const [
          ShortCutItem(title: 'Membership', icon: Icons.person_add_alt_1),
          ShortCutItem(title: 'Book Request', icon: Icons.bookmark_add),
        ],
      ),
    );
  }
}

class ShortCutItem extends StatelessWidget {
  const ShortCutItem({required this.title, required this.icon, super.key});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: size.height / 120,
        children: [
          Icon(icon, size: size.width / 10, color: AppColors.white),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1, color: AppColors.grey);
  }
}
