import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:tasklog/domain/entities/habit_entity.dart';
import 'package:tasklog/presentation/providers/habit_providers.dart';
import '../widgets/color_picker_widget.dart';
import '../widgets/icon_picker_widget.dart';

class HabitFormPage extends ConsumerStatefulWidget {
  final HabitEntity? habit;

  const HabitFormPage({super.key, this.habit});

  @override
  ConsumerState<HabitFormPage> createState() => _HabitFormPageState();
}

class _HabitFormPageState extends ConsumerState<HabitFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _goalController;
  late String _selectedIcon;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.habit?.description ?? '',
    );
    _goalController = TextEditingController(
      text: widget.habit?.goalCount.toString() ?? '1',
    );
    _selectedIcon = widget.habit?.icon ?? AppPalette.habitIcons[0];
    _selectedColor = widget.habit != null
        ? Color(widget.habit!.color)
        : Color(AppPalette.colorValues[0]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.habit != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? l10n.editHabit : l10n.newHabit,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
          children: [
            _buildSectionLabel(l10n.basicInformation),
            const SizedBox(height: AppConstants.spacingLarge),
            _buildNameField(theme, l10n),
            const SizedBox(height: AppConstants.spacingXXLarge),
            _buildGoalField(theme, l10n),
            const SizedBox(height: AppConstants.spacingXXLarge),
            _buildSectionLabel(l10n.appearance),
            const SizedBox(height: AppConstants.spacingLarge),
            IconPickerWidget(
              selectedIcon: _selectedIcon,
              onIconSelected: (icon) => setState(() => _selectedIcon = icon),
              highlightColor: _selectedColor,
              label: l10n.selectIcon,
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),
            ColorPickerWidget(
              selectedColor: _selectedColor,
              onColorSelected: (color) =>
                  setState(() => _selectedColor = color),
              label: l10n.selectColor,
            ),
            const SizedBox(height: AppConstants.spacingHuge),
            _buildSaveButton(context, isEditing, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: AppConstants.fontSizeMedium,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildNameField(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.habitName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaIntense,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: l10n.habitName,
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
            if (value == null || value.trim().isEmpty) {
              return l10n.pleaseEnterHabitName;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGoalField(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dailyGoal,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaIntense,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        TextFormField(
          controller: _goalController,
          decoration: InputDecoration(
            hintText: l10n.dailyGoal,
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
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.pleaseEnterGoal;
            }
            final goal = int.tryParse(value);
            if (goal == null || goal < 1) {
              return l10n.goalMustBeAtLeast1;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    bool isEditing,
    AppLocalizations l10n,
  ) {
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
        onPressed: () => _saveHabit(context, isEditing, l10n),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(
              isEditing ? l10n.updateHabit : l10n.createHabit,
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

  Future<void> _saveHabit(
    BuildContext context,
    bool isEditing,
    AppLocalizations l10n,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final goalCount = int.parse(_goalController.text);

    try {
      if (isEditing) {
        final updatedHabit = widget.habit!.copyWith(
          name: name,
          description: description,
          goalCount: goalCount,
          color: _selectedColor.toARGB32(),
          icon: _selectedIcon,
        );

        final useCase = ref.read(updateHabitUseCaseProvider);
        await useCase(updatedHabit);

        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(l10n.habitUpdated),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
            ),
          );
        }
      } else {
        final newHabit = HabitEntity(
          id: 0, // Will be auto-generated
          name: name,
          description: description,
          goalCount: goalCount,
          color: _selectedColor.toARGB32(),
          icon: _selectedIcon,
          createdAt: DateTime.now(),
        );

        final useCase = ref.read(addHabitUseCaseProvider);
        await useCase(newHabit);

        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(l10n.habitCreated),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error creating/updating habit: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(child: Text(l10n.errorMessage(e.toString()))),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
          ),
        );
      }
    }
  }
}
