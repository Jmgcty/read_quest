import 'package:flutter/material.dart';
import 'package:read_quest/core/utils/enum/user_type_enum.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.userType});
  final UserTypes userType;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Home Screen')));
  }
}
