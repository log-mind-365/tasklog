import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class TodoFormSaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  const TodoFormSaveButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: AppConstants.spacingGiant,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(
              alpha: AppConstants.alphaStrong,
            ),
            blurRadius: AppConstants.spacingLarge,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
