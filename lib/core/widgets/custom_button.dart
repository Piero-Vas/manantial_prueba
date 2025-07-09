import 'package:flutter/material.dart';
import 'package:manantial_prueba/core/colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final String type;
  final double borderRadius;
  final Color? textColorApp;
  final Color? backgroundColorApp;
  final bool disabled;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.type,
    this.borderRadius = 16.0,
    this.textColorApp,
    this.backgroundColorApp,
    this.disabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    double radius = borderRadius;

    switch (type) {
      case 'primary':
        backgroundColor = disabled ? AppColors.grey : AppColors.blue;
        textColor = AppColors.white;
        break;
      case 'secondary':
        backgroundColor = disabled ? AppColors.grey : AppColors.black;
        textColor = AppColors.white;
        break;
      case 'outline_primary':
        backgroundColor = Colors.transparent;
        textColor = disabled ? AppColors.grey : AppColors.blue;
        break;
      case 'outline_secondary':
        backgroundColor = Colors.transparent;
        textColor = disabled ? AppColors.grey : AppColors.black;
        break;
      default:
        backgroundColor = disabled ? AppColors.grey : AppColors.black;
        textColor = AppColors.white;
    }

    if (textColorApp != null) {
      textColor = textColorApp!;
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColorApp ?? backgroundColor,
              foregroundColor: textColorApp ?? textColor,
              elevation: type.startsWith('outline') ? 0 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: type.startsWith('outline')
                    ? BorderSide(color: textColor, width: 2)
                    : BorderSide.none,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            onPressed: disabled ? null : onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8.0),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
