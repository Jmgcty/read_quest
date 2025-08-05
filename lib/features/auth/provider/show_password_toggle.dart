import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowPasswordToggle extends StateNotifier<bool> {
  ShowPasswordToggle() : super(false);

  void toggle() => state = !state;
}

final showPasswordToggleProvider =
    StateNotifierProvider.autoDispose<ShowPasswordToggle, bool>(
      (ref) => ShowPasswordToggle(),
    );
