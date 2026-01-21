import 'package:flutter/material.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';

class CustomSnackBar {
  /// Global messenger key to avoid calling ScaffoldMessenger.of(context)
  /// on deactivated widget contexts (common during async flows + navigation).
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static ScaffoldMessengerState? get _messenger => messengerKey.currentState;
  static BuildContext? get _rootContext => messengerKey.currentContext;

  /// Show a success message (green background)
  static void showSuccess(BuildContext context, String message) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(rootContext).appColors.profit,
        behavior: SnackBarBehavior.floating,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Show an error message (red background)
  static void showError(BuildContext context, String message) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(rootContext).appColors.loss,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show a warning message (orange/amber background)
  static void showWarning(BuildContext context, String message) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(rootContext).appColors.warning,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Show an info message (blue background)
  static void showInfo(BuildContext context, String message) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(rootContext).appColors.info,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Show a secondary/neutral message (uses secondary color)
  static void showSecondary(BuildContext context, String message) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(rootContext).appColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Show a custom snackbar with full control
  static void showCustom(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[Icon(icon, color: textColor ?? Colors.white, size: 20), const SizedBox(width: 12)],
            Expanded(
              child: Text(
                message,
                style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: textColor ?? Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? Theme.of(rootContext).appColors.secondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration ?? const Duration(seconds: 1),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: textColor ?? Colors.white,
                onPressed:
                    onActionPressed ??
                    () {
                      messenger.hideCurrentSnackBar();
                    },
              )
            : null,
      ),
    );
  }

  /// Show a loading snackbar (typically used for ongoing processes)
  static void showLoading(BuildContext context, String message) {
    final messenger = _messenger;
    final rootContext = _rootContext;
    if (messenger == null || rootContext == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white))),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: Theme.of(rootContext).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(rootContext).appColors.secondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(days: 1), // Very long duration for loading states
      ),
    );
  }

  /// Hide the current snackbar
  static void hide(BuildContext context) {
    _messenger?.hideCurrentSnackBar();
  }

  /// Clear all snackbars
  static void clearAll(BuildContext context) {
    _messenger?.clearSnackBars();
  }
}
