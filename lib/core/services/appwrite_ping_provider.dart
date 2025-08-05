import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/services/appwrite.dart';

// Define a provider for Appwrite client

final pingServerProvider = FutureProvider(
  (ref) => ref.read(appwriteClientProvider).ping(),
);

// Define a provider for Appwrite client
