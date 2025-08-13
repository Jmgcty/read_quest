import 'package:flutter/material.dart';
import 'package:read_quest/core/const/app_colors.dart';

class QuizzesPassed extends StatelessWidget {
  const QuizzesPassed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        title: const Text('Quizzes Passed'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: const Center(child: Text('Feature Currently Unavailable')),
    );
  }
}
