import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class CropSaleDetailsScreen extends StatelessWidget {
  final CropSale sale;
  final VoidCallback onBack;
  final VoidCallback onEditSale;
  final Function(CropSale) onCancelSale;

  const CropSaleDetailsScreen({
    Key? key,
    required this.sale,
    required this.onBack,
    required this.onEditSale,
    required this.onCancelSale,
  }) : super(key: key);

  void _confirmCancel(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Cancel Sale Listing',
        message:
            'Are you sure you want to cancel this listing for "${sale.cropName}"? It will no longer be visible to buyers in the marketplace.',
        confirmLabel: 'Cancel Listing',
        cancelLabel: 'Keep Active',
        isDestructive: true,
      ),
    );

    if (result == true) {
      final updated = sale.copyWith(status: 'Cancelled');
      onCancelSale(updated);
      AppUtils.showSnackBar(context, 'Sale listing cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Scaffold(
          backgroundColor: AgroColors.surfaceVariant,
          appBar: AppBar(
            title: const Text('Sale Listing Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: StatusBadge(status: sale.status),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
              vertical: isDesktop ? 24 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Hero Card with Image and Title
                    _buildHeroCard(),
                    const SizedBox(height: 16),

                    // Key Metric Cards (Quantity, Price, Estimated Total)
                    _buildMetricsGrid(constraints.maxWidth),
                    const SizedBox(height: 16),

                    // Detailed Specifications Card
                    _buildSpecificationCard(),
                    const SizedBox(height: 16),

                    // Description / Notes Card
                    if (sale.description.isNotEmpty) ...[
                      _buildDescriptionCard(),
                      const SizedBox(height: 16),
                    ],

                    // Market Visibility Advisory
                    _buildMarketAdvisoryCard(),
                    const SizedBox(height: 24),

                    // Action Controls
                    _buildActionsCard(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foliage Image Banner
          Stack(
            children: [
              Image.network(
                sale.image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: AgroColors.primaryContainer,
                  child: const Center(
                    child: Icon(Icons.eco, size: 64, color: AgroColors.primary),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: StatusBadge(status: sale.status, fontSize: 13),
              ),
              if (sale.postedDate.isNotEmpty)
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 13, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(
                          'Posted: ${sale.postedDate}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Crop Name & Variety Header
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sale.cropName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AgroColors.textDark,
                            ),
                          ),
                          if (sale.variety.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Variety: ${sale.variety}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AgroColors.primaryDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AgroColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Listing ID',
                            style: TextStyle(fontSize: 10, color: AgroColors.primaryDark, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            sale.id.toUpperCase(),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(double maxWidth) {
    final isCompact = maxWidth < 480;

    return isCompact
        ? Column(
            children: [
              _buildMetricCard(
                title: 'Available Quantity',
                value: '${sale.quantity} ${sale.unit}',
                icon: Icons.scale,
                iconColor: Colors.blue.shade700,
                bgColor: Colors.blue.shade50,
              ),
              const SizedBox(height: 10),
              _buildMetricCard(
                title: 'Expected Price',
                value: '₹${sale.price.toStringAsFixed(0)} / ${sale.unit}',
                icon: Icons.currency_rupee,
                iconColor: Colors.green.shade800,
                bgColor: Colors.green.shade50,
              ),
              const SizedBox(height: 10),
              _buildMetricCard(
                title: 'Total Estimated Value',
                value: '₹${sale.totalEstimatedValue.toStringAsFixed(0)}',
                icon: Icons.account_balance_wallet,
                iconColor: Colors.purple.shade700,
                bgColor: Colors.purple.shade50,
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Available Quantity',
                  value: '${sale.quantity} ${sale.unit}',
                  icon: Icons.scale,
                  iconColor: Colors.blue.shade700,
                  bgColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Expected Price',
                  value: '₹${sale.price.toStringAsFixed(0)} / ${sale.unit}',
                  icon: Icons.currency_rupee,
                  iconColor: Colors.green.shade800,
                  bgColor: Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Total Estimated Value',
                  value: '₹${sale.totalEstimatedValue.toStringAsFixed(0)}',
                  icon: Icons.account_balance_wallet,
                  iconColor: Colors.purple.shade700,
                  bgColor: Colors.purple.shade50,
                ),
              ),
            ],
          );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: bgColor,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: AgroColors.textMuted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listing Specifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 14),
            _buildSpecRow(
              icon: Icons.calendar_month,
              label: 'Harvest / Ready Date',
              value: sale.availableDate.isNotEmpty ? sale.availableDate : 'Immediately Available',
            ),
            const Divider(height: 20, color: AgroColors.border),
            _buildSpecRow(
              icon: Icons.location_on,
              label: 'Farm Village / Location',
              value: sale.location,
            ),
            const Divider(height: 20, color: AgroColors.border),
            _buildSpecRow(
              icon: Icons.monetization_on_outlined,
              label: 'Price Unit Structure',
              value: sale.effectivePriceUnit,
            ),
            const Divider(height: 20, color: AgroColors.border),
            _buildSpecRow(
              icon: Icons.verified_user_outlined,
              label: 'Marketplace Listing Status',
              value: sale.status,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AgroColors.primary),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AgroColors.textMuted, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.notes, size: 20, color: AgroColors.primary),
                SizedBox(width: 8),
                Text(
                  'Harvest Description & Quality Notes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              sale.description,
              style: const TextStyle(fontSize: 14, color: AgroColors.textDark, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketAdvisoryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.insights, color: AgroColors.primaryDark, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marketplace Visibility',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AgroColors.primaryDark),
                ),
                SizedBox(height: 4),
                Text(
                  'This sale listing is visible to verified local wholesale dealers, direct consumers, and food processing mills. When a buyer initiates an inquiry, you will receive an instant notification.',
                  style: TextStyle(fontSize: 12, color: AgroColors.textMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    if (sale.isCancelled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Listing is Cancelled',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'This listing has been cancelled and is no longer active in the marketplace.',
              style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onBack,
              child: const Text('Back to My Sales'),
            ),
          ],
        ),
      );
    }

    if (sale.isSold) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Color(0xFF512DA8)),
                SizedBox(width: 10),
                Text(
                  'Listing is Marked as Sold',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF512DA8)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'This harvest has been successfully sold and fulfilled.',
              style: TextStyle(fontSize: 13, color: AgroColors.textMuted),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onBack,
              child: const Text('Back to My Sales'),
            ),
          ],
        ),
      );
    }

    // Active listing actions
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: 'Edit Sale Listing',
          icon: Icons.edit,
          onPressed: onEditSale,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _confirmCancel(context),
          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
          label: const Text('Cancel Listing', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Colors.red, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onBack,
          child: const Text('Back to My Sales', style: TextStyle(color: AgroColors.textMuted)),
        ),
      ],
    );
  }
}
