import 'package:flutter/material.dart';
import 'package:ipo_lens/core/theme/app_theme.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'package:ipo_lens/utils/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTheme.heading1.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Customize your app experience',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  children: const [
                    _ThemeModeTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;
    final provider = context.watch<ThemeProvider>();

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: c.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.color_lens_rounded, color: c.secondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Theme',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            label: 'System',
            value: ThemeMode.system,
            groupValue: provider.themeMode,
            onChanged: provider.setThemeMode,
          ),
          _ThemeOption(
            label: 'Light',
            value: ThemeMode.light,
            groupValue: provider.themeMode,
            onChanged: provider.setThemeMode,
          ),
          _ThemeOption(
            label: 'Dark',
            value: ThemeMode.dark,
            groupValue: provider.themeMode,
            onChanged: provider.setThemeMode,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final ThemeMode value;
  final ThemeMode groupValue;
  final void Function(ThemeMode) onChanged;

  const _ThemeOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return RadioListTile<ThemeMode>(
      value: value,
      groupValue: groupValue,
      onChanged: (v) {
        if (v == null) return;
        onChanged(v);
      },
      activeColor: c.secondary,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: c.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        value == ThemeMode.system
            ? 'Follow device setting'
            : value == ThemeMode.light
                ? 'Light background'
                : 'Dark background',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: c.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
