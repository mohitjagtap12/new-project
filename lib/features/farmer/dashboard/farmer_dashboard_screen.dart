import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/dashboard_card.dart';
import '../../auth/auth_service.dart';

class FarmerDashboardScreen extends StatelessWidget {
  final int cropsCount;
  final int ordersCount;
  final int labourRequestsCount;
  final int salesCount;
  final VoidCallback onNavigateCrops;
  final VoidCallback onNavigateOrders;
  final VoidCallback onNavigateLabour;
  final VoidCallback onNavigateSales;
  final VoidCallback onNavigateAddCrop;
  final VoidCallback onNavigateSellCrop;
  final VoidCallback onNavigateCropHealth;
  final VoidCallback onNavigateFarmWaste;
  final VoidCallback onNavigateProducts;
  final VoidCallback onNavigateContracts;
  final VoidCallback? onNavigateMarket;
  final VoidCallback? onNavigateNotifications;
  final VoidCallback? onNavigateProfile;

  const FarmerDashboardScreen({
    Key? key,
    required this.cropsCount,
    required this.ordersCount,
    required this.labourRequestsCount,
    required this.salesCount,
    required this.onNavigateCrops,
    required this.onNavigateOrders,
    required this.onNavigateLabour,
    required this.onNavigateSales,
    required this.onNavigateAddCrop,
    required this.onNavigateSellCrop,
    required this.onNavigateCropHealth,
    required this.onNavigateFarmWaste,
    required this.onNavigateProducts,
    required this.onNavigateContracts,
    this.onNavigateMarket,
    this.onNavigateNotifications,
    this.onNavigateProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final farmerName = AuthService.instance.currentUser?.name ?? 'Farmer';

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth >= 900;
        final isTablet = screenWidth >= 600 && screenWidth < 900;

        // Determine column counts adaptively for desktop, tablet, and mobile
        final summaryCrossAxisCount = isDesktop ? 4 : (isTablet ? 4 : 2);
        final summaryAspectRatio = isDesktop ? 1.6 : (isTablet ? 1.35 : (screenWidth < 360 ? 1.15 : 1.3));

        final quickActionCrossAxisCount = isDesktop ? 4 : (isTablet ? 4 : 2);
        final quickActionAspectRatio = isDesktop ? 1.4 : (isTablet ? 1.25 : (screenWidth < 360 ? 1.1 : 1.2));

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : 16,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isDesktop ? 24 : 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AgroColors.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $farmerName!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Manage your farm easily • स्मार्ट शेतकरी',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE8F5E9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Summary Section
              const Text(
                'Farm Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Summary Cards (My Crops, My Orders, Labour, My Sales)
              GridView.count(
                crossAxisCount: summaryCrossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: summaryAspectRatio,
                children: [
                  DashboardCard(
                    title: 'My Crops',
                    value: '$cropsCount',
                    icon: Icons.eco,
                    iconColor: AgroColors.primary,
                    backgroundColor: AgroColors.primaryContainer,
                    onTap: onNavigateCrops,
                  ),
                  DashboardCard(
                    title: 'My Orders',
                    value: '$ordersCount',
                    icon: Icons.receipt_long,
                    iconColor: Colors.blue.shade700,
                    backgroundColor: Colors.blue.shade50,
                    onTap: onNavigateOrders,
                  ),
                  DashboardCard(
                    title: 'Labour Requests',
                    value: '$labourRequestsCount',
                    icon: Icons.people,
                    iconColor: Colors.orange.shade800,
                    backgroundColor: Colors.orange.shade50,
                    onTap: onNavigateLabour,
                  ),
                  DashboardCard(
                    title: 'My Sales',
                    value: '$salesCount',
                    icon: Icons.sell,
                    iconColor: Colors.purple.shade700,
                    backgroundColor: Colors.purple.shade50,
                    onTap: onNavigateSales,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Quick Actions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AgroColors.textDark,
                    ),
                  ),
                  Text(
                    'Tap to start',
                    style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Touch-friendly Quick Actions
              GridView.count(
                crossAxisCount: quickActionCrossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: quickActionAspectRatio,
                children: [
                  QuickActionCard(
                    label: 'Add Crop',
                    icon: Icons.add_circle,
                    color: AgroColors.primary,
                    onTap: onNavigateAddCrop,
                  ),
                  QuickActionCard(
                    label: 'Sell Crop',
                    icon: Icons.storefront,
                    color: Colors.amber.shade900,
                    onTap: onNavigateSellCrop,
                  ),
                  QuickActionCard(
                    label: 'Find Labour',
                    icon: Icons.group_add,
                    color: Colors.blue.shade700,
                    onTap: onNavigateLabour,
                  ),
                  QuickActionCard(
                    label: 'Check Crop Health',
                    icon: Icons.health_and_safety,
                    color: Colors.teal.shade700,
                    onTap: onNavigateCropHealth,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Explore More Farm Services
              const Text(
                'More Farm Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              if (isDesktop)
                Row(
                  children: [
                    Expanded(
                      child: _serviceCard(
                        context,
                        icon: Icons.recycling,
                        title: 'Sell Farm Waste',
                        subtitle: 'Earn money from straw & biomass',
                        color: Colors.brown.shade600,
                        onTap: onNavigateFarmWaste,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _serviceCard(
                        context,
                        icon: Icons.shopping_basket,
                        title: 'Buy Farm Products',
                        subtitle: 'Seeds, fertilizers & equipment',
                        color: AgroColors.primary,
                        onTap: onNavigateProducts,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _serviceCard(
                        context,
                        icon: Icons.handshake,
                        title: 'Farm Contracts',
                        subtitle: 'Direct buy corporate agreements',
                        color: Colors.indigo.shade700,
                        onTap: onNavigateContracts,
                      ),
                    ),
                  ],
                )
              else ...[
                _serviceTile(
                  context,
                  icon: Icons.recycling,
                  title: 'Sell Farm Waste',
                  subtitle: 'Earn money from straw, stalks & biomass',
                  color: Colors.brown.shade600,
                  onTap: onNavigateFarmWaste,
                ),
                const SizedBox(height: 10),
                _serviceTile(
                  context,
                  icon: Icons.shopping_basket,
                  title: 'Buy Farm Products',
                  subtitle: 'Seeds, fertilizers, tools & equipment',
                  color: AgroColors.primary,
                  onTap: onNavigateProducts,
                ),
                const SizedBox(height: 10),
                _serviceTile(
                  context,
                  icon: Icons.handshake,
                  title: 'Farm Contracts',
                  subtitle: 'Direct buy agreements with food companies',
                  color: Colors.indigo.shade700,
                  onTap: onNavigateContracts,
                ),
              ],

              // Market & Profile Quick Access on Mobile if provided
              if (!isDesktop && (onNavigateMarket != null || onNavigateProfile != null)) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (onNavigateMarket != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onNavigateMarket,
                          icon: const Icon(Icons.storefront, size: 18),
                          label: const Text('Open Market'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AgroColors.primaryDark,
                            side: const BorderSide(color: AgroColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    if (onNavigateMarket != null && onNavigateProfile != null)
                      const SizedBox(width: 12),
                    if (onNavigateProfile != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onNavigateProfile,
                          icon: const Icon(Icons.person, size: 18),
                          label: const Text('My Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AgroColors.textDark,
                            side: const BorderSide(color: AgroColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _serviceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AgroColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AgroColors.textLight),
        onTap: onTap,
      ),
    );
  }
}
