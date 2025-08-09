import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_form_provider.dart';

class AddBookProvider extends StateNotifier<PageController> {
  WidgetRef ref;
  int pageIndex = 0;
  AddBookProvider({required this.ref}) : super(PageController(initialPage: 0));

  void changePage(int index) {
    pageIndex = index;
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextPage() {
    final formKey = ref.watch(formKeyProvider);
    final file = ref.watch(fileFormProvider);
    if (pageIndex == 2) return;
    if (!formKey.currentState!.validate()) return;
    if (pageIndex == 1) {
      if (file == null) return;
    }

    //
    pageIndex++;
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    if (pageIndex == 0) return;
    pageIndex--;
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void resetPage() {
    pageIndex = 0;
  }
}

final addBookPageProvider = StateNotifierProvider.autoDispose
    .family<AddBookProvider, PageController, WidgetRef>(
      (ref, widgetRef) => AddBookProvider(ref: widgetRef),
    );
