import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';

class TodoFormTitleField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function()? validator;

  const TodoFormTitleField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaIntense,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.enterTodoTitle,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: AppConstants.alphaStrong,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXXLarge,
              vertical: AppConstants.spacingXLarge,
            ),
          ),
          style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
          validator: (value) {
            if (validator != null) {
              final error = validator!();
              if (error != null) {
                return l10n.pleaseEnterTitle;
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
