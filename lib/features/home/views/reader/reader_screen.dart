import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/utils/formatter.dart';
import 'package:read_quest/features/home/enum/page_names.dart';
import 'package:read_quest/features/home/views/admin/provider/page_provider.dart';
import 'package:read_quest/features/home/views/reader/screens/book/reader_book_screen.dart';
import 'package:read_quest/features/home/views/reader/screens/game/reader_game_screen.dart';
import 'package:read_quest/features/home/views/reader/screens/home/reader_home_screen.dart';
import 'package:read_quest/features/home/views/reader/screens/other/reader_more_settings_screen.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final screens = [
    ReaderHomeScreen(),
    ReaderBookScreen(),
    ReaderGameScreen(),
    ReaderMoreSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(adminPageProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
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
          icon: Icon(Icons.home),
          label: formatStringToCapitalFirstLetter(ReaderPageName.home.name),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: formatStringToCapitalFirstLetter(ReaderPageName.books.name),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.games),
          label: formatStringToCapitalFirstLetter(ReaderPageName.games.name),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_sharp),
          label: formatStringToCapitalFirstLetter(ReaderPageName.others.name),
        ),
      ],
    );
  }
}
