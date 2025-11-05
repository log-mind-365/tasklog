import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';

class TodoFormDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const TodoFormDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
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
            hintText: l10n.descriptionHint,
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
          maxLines: 4,
          style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
        ),
      ],
    );
  }
}
