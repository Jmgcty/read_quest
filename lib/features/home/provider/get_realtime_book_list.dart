import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/home/repository/book_repository.dart';

final getRealTimeAcceptedBooksProvider = StreamProvider(
  (ref) => ref.read(bookRepositoryProvider).getRealTimeAcceptedBooks(),
);
