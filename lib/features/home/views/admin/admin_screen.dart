import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/utils/formatter.dart';
import 'package:read_quest/features/home/enum/admin_page_name.dart';
import 'package:read_quest/features/home/views/admin/provider/page_provider.dart';
import 'package:read_quest/features/home/views/admin/screen/books/book_screen.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/dashboard_screen.dart';
import 'package:read_quest/features/home/views/admin/screen/games/game_screen.dart';
import 'package:read_quest/features/home/views/admin/screen/other/setting_screen.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final screens = [
    DashboardScreen(),
    BookScreen(),
    GameScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(adminPageProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        title: Text(formatStringToCapitalFirstLetter(page.name)),
        centerTitle: true,
      ),
      body: screens[page.customIndex],
      bottomNavigationBar: AdminBottomNavigationBar(),
    );
  }
}

class AdminBottomNavigationBar extends ConsumerStatefulWidget {
  const AdminBottomNavigationBar({super.key});

  @override
  ConsumerState<AdminBottomNavigationBar> createState() =>
      _AdminBottomNavigationBarState();
}

class _AdminBottomNavigationBarState
    extends ConsumerState<AdminBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final page = ref.watch(adminPageProvider);
    final pageProvider = ref.read(adminPageProvider.notifier);

    //
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 6.0,
      selectedItemColor: AppColors.primary,
      backgroundColor: AppColors.backgroundWhite,
      currentIndex: page.customIndex,
      onTap: (index) => pageProvider.changePage(index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: formatStringToCapitalFirstLetter(AdminPageName.dashboard.name),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: formatStringToCapitalFirstLetter(AdminPageName.books.name),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.games),
          label: formatStringToCapitalFirstLetter(AdminPageName.games.name),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_sharp),
          label: formatStringToCapitalFirstLetter(AdminPageName.others.name),
        ),
      ],
    );
  }
}
