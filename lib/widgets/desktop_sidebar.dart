import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class DesktopSidebarItem {
  final String title;
  final IconData icon;
  final String routeId;
  final int? badgeCount;

  DesktopSidebarItem({
    required this.title,
    required this.icon,
    required this.routeId,
    this.badgeCount,
  });
}

class DesktopSidebar extends StatelessWidget {
  final String selectedRoute;
  final ValueChanged<String> onSelectRoute;
  final int unreadNotifications;

  const DesktopSidebar({
    Key? key,
    required this.selectedRoute,
    required this.onSelectRoute,
    this.unreadNotifications = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DesktopSidebarItem> items = [
      DesktopSidebarItem(title: 'Home', icon: Icons.home, routeId: 'home'),
      DesktopSidebarItem(title: 'My Crops', icon: Icons.eco, routeId: 'crops'),
      DesktopSidebarItem(title: 'Sell Crop', icon: Icons.sell, routeId: 'sell_crop'),
      DesktopSidebarItem(title: 'Sell Farm Waste', icon: Icons.recycling, routeId: 'farm_waste'),
      DesktopSidebarItem(title: 'Find Labour', icon: Icons.people, routeId: 'labour'),
      DesktopSidebarItem(title: 'Buy Products', icon: Icons.shopping_bag, routeId: 'products'),
      DesktopSidebarItem(title: 'Farm Contracts', icon: Icons.description, routeId: 'contracts'),
      DesktopSidebarItem(title: 'My Orders', icon: Icons.receipt_long, routeId: 'orders'),
      DesktopSidebarItem(title: 'Market', icon: Icons.storefront, routeId: 'market'),
      DesktopSidebarItem(title: 'Notifications', icon: Icons.notifications, routeId: 'notifications', badgeCount: unreadNotifications),
      DesktopSidebarItem(title: 'Profile', icon: Icons.person, routeId: 'profile'),
      DesktopSidebarItem(title: 'Help', icon: Icons.help_outline, routeId: 'help'),
    ];

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AgroColors.border, width: 1)),
      ),
      child: Column(
        children: [
          // Logo & App Name Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AgroColors.border, width: 1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AgroColors.primaryContainer,
                  child: const Icon(Icons.agriculture, color: AgroColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AgroWorld',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AgroColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Farmer Portal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AgroColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Navigation Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedRoute == item.routeId;

                return Material(
                  color: isSelected ? AgroColors.primaryContainer : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => onSelectRoute(item.routeId),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 20,
                            color: isSelected ? AgroColors.primaryDark : AgroColors.textMuted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                              ),
                            ),
                          ),
                          if (item.badgeCount != null && item.badgeCount! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.badgeCount.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // User mini footer card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AgroColors.border, width: 1)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AgroColors.primaryContainer,
                  child: Icon(Icons.person, color: AgroColors.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Ramesh Patil',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                      ),
                      Text(
                        'Pune, MH',
                        style: TextStyle(fontSize: 12, color: AgroColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
