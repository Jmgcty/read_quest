import 'package:go_router/go_router.dart';
import 'package:read_quest/features/auth/views/login_screen.dart';
import 'package:read_quest/features/auth/views/register_screen.dart';
import 'package:read_quest/features/home/start/views/get_started_screen.dart';
import 'package:read_quest/features/home/views/home_screen.dart';
import 'package:read_quest/router/route_name_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: RouteName.root.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteName.root.path,
        name: RouteName.root.name,
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: RouteName.login.path,
        name: RouteName.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteName.register.path,
        name: RouteName.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteName.home.path,
        name: RouteName.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  ),
);
