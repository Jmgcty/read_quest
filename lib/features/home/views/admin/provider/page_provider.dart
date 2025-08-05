import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/home/enum/admin_page_name.dart';

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
