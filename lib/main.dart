import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/firebase_options.dart';
import 'package:read_quest/router/app_router.dart';
import 'package:read_quest/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Flutter Read Quest',
      theme: AppTheme.light,
      routerConfig: routerConfig,
      debugShowCheckedModeBanner: false,
    );
  }
}
