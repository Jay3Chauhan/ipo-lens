import 'package:flutter/material.dart';
import 'package:ipo_lens/core/theme/app_theme.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';

class BidScreen extends StatelessWidget {
  const BidScreen({super.key});

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
                'Bids',
                style: AppTheme.heading1.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming soon',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.gavel_rounded, color: c.secondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This tab will track your IPO applications/bids.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: c.textSecondary,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
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
