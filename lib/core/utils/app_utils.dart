import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppUtils {
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? Colors.red.shade700 : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  /// Format an amount into Indian Rupee format (e.g., ₹1,250 or ₹1,250.50)
  static String formatCurrency(num amount, {bool showDecimal = false}) {
    if (showDecimal) {
      return '₹${amount.toStringAsFixed(2)}';
    }
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        )}';
  }

  /// Format a DateTime into readable date (e.g. 15 Oct 2024)
  static String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Get status color mapped from semantic status names
  static Color getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('growing') || s.contains('active') || s.contains('delivered') || s.contains('completed') || s.contains('accepted')) {
      return AgroColors.statusGrowing;
    }
    if (s.contains('harvest') || s.contains('shipped') || s.contains('processing')) {
      return AgroColors.statusHarvested;
    }
    if (s.contains('available') || s.contains('placed')) {
      return AgroColors.statusAvailable;
    }
    if (s.contains('pending')) {
      return AgroColors.statusPending;
    }
    if (s.contains('cancel') || s.contains('rejected')) {
      return AgroColors.statusCancelled;
    }
    return AgroColors.textMuted;
  }
}

