import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/home/enum/page_names.dart';

class AdminPageState extends StateNotifier<AdminPageName> {
  AdminPageState() : super(AdminPageName.dashboard);

  void changePage(int index) {
    state = AdminPageName.fromIndex(index);
  }

  void resetPage() {
    state = AdminPageName.dashboard;
  }
}

final adminPageProvider = StateNotifierProvider<AdminPageState, AdminPageName>(
  (ref) => AdminPageState(),
);

// READER
class ReaderPageState extends StateNotifier<ReaderPageName> {
  ReaderPageState() : super(ReaderPageName.home);

  void changePage(int index) {
    state = ReaderPageName.fromIndex(index);
  }

  void resetPage() {
    state = ReaderPageName.home;
  }
}

final readerPageProvider =
    StateNotifierProvider<ReaderPageState, ReaderPageName>(
      (ref) => ReaderPageState(),
    );
