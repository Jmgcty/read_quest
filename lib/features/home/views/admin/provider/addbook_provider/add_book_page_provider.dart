import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_form_provider.dart';

class AddBookProvider extends StateNotifier<PageController> {
  WidgetRef ref;
  int pageIndex = 0;
  AddBookProvider({required this.ref}) : super(PageController(initialPage: 0));

  void changePage(int index) {
    pageIndex = index;
    ref.read(addBookButtonLabelProvider.notifier).changeLabel(pageIndex);
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextPage() {
    final formKey = ref.read(formKeyProvider);
    final file = ref.read(fileFormProvider);
    if (pageIndex == 2) return;
    if (pageIndex == 1) {
      if (file == null) return;
    }
    if (!formKey.currentState!.validate()) return;

    //
    pageIndex++;
    ref.read(addBookButtonLabelProvider.notifier).changeLabel(pageIndex);
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    if (pageIndex == 0) return;

    //
    pageIndex--;
    ref.read(addBookButtonLabelProvider.notifier).changeLabel(pageIndex);
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void resetPage() {
    pageIndex = 0;
    ref.read(addBookButtonLabelProvider.notifier).changeLabel(pageIndex);
    state.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

final addBookPageProvider = StateNotifierProvider.autoDispose
    .family<AddBookProvider, PageController, WidgetRef>(
      (ref, widgetRef) => AddBookProvider(ref: widgetRef),
    );

//

class AddBookButtonLabelProvider extends StateNotifier<Map<String, String>> {
  AddBookButtonLabelProvider() : super({'prev': 'Cancel', 'next': 'Next'});

  void changeLabel(int index) {
    if (index == 0) {
      state = {'prev': 'Cancel', 'next': 'Next'};
    } else if (index == 2) {
      state = {'prev': 'Back', 'next': 'Upload'};
    } else {
      state = {'prev': 'Back', 'next': 'Next'};
    }
  }
}

final addBookButtonLabelProvider =
    StateNotifierProvider.autoDispose<
      AddBookButtonLabelProvider,
      Map<String, String>
    >((ref) => AddBookButtonLabelProvider());
