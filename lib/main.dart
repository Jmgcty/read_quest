import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/features/start/views/get_started_screen.dart';
import 'package:read_quest/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Read Quest',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: GetStartedScreen(),
    );
  }
}
