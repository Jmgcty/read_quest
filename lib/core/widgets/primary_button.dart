import 'package:flutter/material.dart';
import 'package:read_quest/core/const/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.disabled = false,
    this.color,
    this.onPressed,
    super.key,
  });

  final String label;
  final bool disabled;
  final VoidCallback? onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return ElevatedButton(
      style: theme.elevatedButtonTheme.style?.copyWith(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: size.height / 70),
        ),
        fixedSize: WidgetStateProperty.all(Size.fromWidth(size.width)),
        backgroundColor: WidgetStateProperty.all(
          disabled ? AppColors.disabled : color ?? AppColors.secondary,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: theme.textTheme.headlineMedium!.copyWith(
          color: AppColors.white,
          fontSize: size.width / 16,
        ),
      ),
    );
  }
}
