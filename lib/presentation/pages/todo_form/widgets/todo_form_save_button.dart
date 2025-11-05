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
    return SizedBox(
      height: AppConstants.spacingGiant,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: AppConstants.iconSizeMedium,
                width: AppConstants.iconSizeMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }
}
