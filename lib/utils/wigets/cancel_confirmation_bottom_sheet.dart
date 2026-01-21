import 'package:flutter/material.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';

class CancelConfirmationBottomSheet {
  static Future<void> show({
    required BuildContext context,
    String title = 'Cancel?',
    String message = 'Are you sure you want to cancel this process? You can always come back later.',
    String cancelText = 'Go Back',
    String confirmText = 'Yes, Cancel',
    IconData icon = Icons.warning_rounded,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).appColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Theme.of(sheetContext).appColors.textTertiary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Theme.of(sheetContext).appColors.warning.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(icon, size: 32, color: Theme.of(sheetContext).appColors.warning),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Theme.of(sheetContext).appColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Theme.of(sheetContext).appColors.textSecondary, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(sheetContext).appColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            cancelText,
                            style: TextStyle(color: Theme.of(sheetContext).appColors.primary, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            Future.microtask(onConfirm);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(sheetContext).appColors.secondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            confirmText,
                            style: TextStyle(color: Theme.of(sheetContext).appColors.background, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
