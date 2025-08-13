import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/home/repository/book_repository.dart';

final getBooksProvider = FutureProvider(
  (ref) async => ref.watch(bookRepositoryProvider).fetchBooks(),
);
