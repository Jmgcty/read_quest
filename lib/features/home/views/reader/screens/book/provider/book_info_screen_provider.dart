import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BookMode { game, book }

class ChangeMode extends StateNotifier<BookMode> {
  ChangeMode() : super(BookMode.book);
  void changeMode(BookMode mode) => state = mode;
}

final changeBookModeProvider =
    StateNotifierProvider.autoDispose<ChangeMode, BookMode>(
      (ref) => ChangeMode(),
    );
