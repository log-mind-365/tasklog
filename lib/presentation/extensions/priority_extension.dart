import 'package:flutter/material.dart';
import '../../domain/entities/priority.dart';
import '../../l10n/app_localizations.dart';

extension PriorityLocalization on Priority {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case Priority.low:
        return l10n.priorityLow;
      case Priority.medium:
        return l10n.priorityMedium;
      case Priority.high:
        return l10n.priorityHigh;
    }
  }
}
