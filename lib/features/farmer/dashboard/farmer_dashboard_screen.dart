import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/dashboard_card.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                    children: const [
                      Text(
                        'Hello, Farmer!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Manage your farm easily',
                        style: TextStyle(
                          fontSize: 15,
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

          // 4 Summary Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
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
                title: 'Labour',
                value: '$labourRequestsCount Requests',
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

          // Large Touch-friendly Quick Actions
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
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

          // Explore More Services Banner
          const Text(
            'More Farm Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AgroColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 24),
        ],
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
