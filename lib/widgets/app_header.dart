import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final int unreadCount;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const AppHeader({
    Key? key,
    required this.title,
    this.onNotificationTap,
    this.onProfileTap,
    this.unreadCount = 2,
    this.showBackButton = false,
    this.onBackTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AgroColors.textDark, size: 26),
              onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                backgroundColor: AgroColors.primaryContainer,
                child: const Icon(Icons.agriculture, color: AgroColors.primary, size: 24),
              ),
            ),
      title: Row(
        children: [
          if (!showBackButton) ...[
            const Text(
              'AgroWorld',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AgroColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AgroColors.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Farmer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.primaryDark,
                ),
              ),
            ),
          ] else ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AgroColors.textDark,
              ),
            ),
          ],
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AgroColors.textDark, size: 26),
              tooltip: 'Notifications',
              onPressed: onNotificationTap,
            ),
            if (unreadCount > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: AgroColors.primaryContainer,
            child: Icon(Icons.person, color: AgroColors.primary, size: 20),
          ),
          tooltip: 'My Profile',
          onPressed: onProfileTap,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
