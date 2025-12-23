import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onPressed;
  final bool isGoogle;

  const SocialLoginButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.isGoogle = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.inputBorder, width: 1.5),
          color: onPressed == null ? Colors.grey[300] : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            color: onPressed == null ? Colors.grey : null,
            colorBlendMode: onPressed == null ? BlendMode.saturation : null,
          ),
        ),
      ),
    );
  }
}
