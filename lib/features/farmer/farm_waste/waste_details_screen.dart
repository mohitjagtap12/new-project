import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/farm_waste.dart';
import '../../../widgets/primary_button.dart';

class WasteDetailsScreen extends StatelessWidget {
  final FarmWaste waste;
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onMarkAsSold;
  final VoidCallback? onCancelListing;
  final VoidCallback onBack;

  const WasteDetailsScreen({
    Key? key,
    required this.waste,
    this.isOwner = false,
    this.onEdit,
    this.onMarkAsSold,
    this.onCancelListing,
    required this.onBack,
  }) : super(key: key);

  void _showContactSellerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.brown.shade100,
                  child: Icon(Icons.person, color: Colors.brown.shade800),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        waste.sellerName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                      ),
                      Text(
                        waste.location,
                        style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            // Direct Contact Options
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AgroColors.primaryContainer,
                child: Icon(Icons.phone, color: AgroColors.primaryDark),
              ),
              title: const Text('Direct Phone Call', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(waste.sellerPhone),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                AppUtils.showSnackBar(context, 'Calling seller at ${waste.sellerPhone} (Mock Connection)');
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Icon(Icons.chat, color: Colors.green.shade800),
              ),
              title: const Text('Chat / WhatsApp Enquiry', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Inquire about bulk quantity and loading availability'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                AppUtils.showSnackBar(context, 'Opening enquiry chat with ${waste.sellerName} (Mock)');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyEnquiryDialog(BuildContext context) {
    final qtyController = TextEditingController(text: waste.quantity);
    final offerPriceController = TextEditingController(text: waste.price.toStringAsFixed(0));
    final noteController = TextEditingController(text: 'Requesting pickup availability next week. Will arrange truck.');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.shopping_bag_outlined, color: AgroColors.primary),
              SizedBox(width: 10),
              Text('Buy / Enquire Waste'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item: ${waste.wasteType}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Listed: ${waste.formattedQuantity} @ ${waste.formattedPrice}/${waste.quantityUnit}',
                  style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                ),
                const SizedBox(height: 16),

                const Text('Required Quantity *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: waste.quantityUnit,
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),

                const Text('Offer Price (₹ per unit) *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: offerPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '₹ ',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),

                const Text('Delivery / Transport Note', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Will pick up with tractor trailer',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, size: 16, color: Colors.brown),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No payment required now. This sends a direct buy proposal to the farmer.',
                          style: TextStyle(fontSize: 11, color: Colors.brown),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                showDialog(
                  context: context,
                  builder: (confirmCtx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Row(
                      children: const [
                        Icon(Icons.check_circle, color: AgroColors.primary, size: 26),
                        SizedBox(width: 10),
                        Text('Purchase Request Sent'),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your offer of ₹${offerPriceController.text.trim()}/${waste.quantityUnit} for ${qtyController.text.trim()} ${waste.quantityUnit} of ${waste.wasteType} has been communicated to ${waste.sellerName}.',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'The seller will contact your registered mobile number for pickup timing.',
                          style: TextStyle(fontSize: 12, color: AgroColors.textMuted),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(confirmCtx).pop(),
                        child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Offer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBg;

    if (waste.isActive) {
      statusColor = AgroColors.primaryDark;
      statusBg = AgroColors.primaryContainer;
    } else if (waste.isSold) {
      statusColor = Colors.blue.shade800;
      statusBg = Colors.blue.shade50;
    } else {
      statusColor = Colors.red.shade800;
      statusBg = Colors.red.shade50;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Listing Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        actions: [
          if (isOwner && waste.isActive && onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Listing',
              onPressed: onEdit,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waste Hero Image
            Stack(
              children: [
                Image.network(
                  waste.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.brown.shade100,
                    child: Icon(Icons.recycling, size: 64, color: Colors.brown.shade400),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      waste.wasteType,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      waste.status,
                      style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price Block
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              waste.wasteType,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AgroColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Posted: ${waste.postedDate}',
                              style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${waste.formattedPrice}/${waste.quantityUnit}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AgroColors.primary,
                            ),
                          ),
                          Text(
                            'Total Est: ₹${waste.totalEstimatedValue.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AgroColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Key Metrics Grid
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF9F6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMetric(
                            icon: Icons.scale,
                            label: 'Total Available',
                            value: waste.formattedQuantity,
                          ),
                        ),
                        Container(height: 40, width: 1, color: AgroColors.border),
                        Expanded(
                          child: _buildMetric(
                            icon: Icons.event_available,
                            label: 'Available Date',
                            value: waste.availableDate,
                          ),
                        ),
                        Container(height: 40, width: 1, color: AgroColors.border),
                        Expanded(
                          child: _buildMetric(
                            icon: Icons.location_on_outlined,
                            label: 'Farm Location',
                            value: waste.location.split(',').first,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seller Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seller Information',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.brown.shade100,
                              child: Icon(Icons.person, size: 28, color: Colors.brown.shade800),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        waste.sellerName,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                      ),
                                      if (isOwner)
                                        Container(
                                          margin: const EdgeInsets.only(left: 6),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AgroColors.primaryContainer,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('You', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgroColors.primaryDark)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    waste.location,
                                    style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            if (!isOwner)
                              IconButton(
                                icon: const Icon(Icons.phone, color: AgroColors.primary),
                                onPressed: () => _showContactSellerDialog(context),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description & Quality Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: Text(
                      waste.description.isNotEmpty
                          ? waste.description
                          : 'High-quality sun-dried farm residue ready for agricultural or industrial use.',
                      style: const TextStyle(fontSize: 14, color: AgroColors.textDark, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recommended Applications
                  if (waste.recommendedUses.isNotEmpty) ...[
                    const Text(
                      'Recommended Applications',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: waste.recommendedUses.map((use) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.brown.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.brown.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check, size: 14, color: Colors.brown),
                              const SizedBox(width: 6),
                              Text(
                                use,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.brown.shade900),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Action Buttons
                  if (isOwner) ...[
                    if (waste.isActive) ...[
                      PrimaryButton(
                        label: 'Mark as Sold',
                        icon: Icons.task_alt,
                        color: AgroColors.primary,
                        onPressed: () {
                          if (onMarkAsSold != null) onMarkAsSold!();
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (onEdit != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: onEdit,
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Listing'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          if (onEdit != null && onCancelListing != null) const SizedBox(width: 12),
                          if (onCancelListing != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: onCancelListing,
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                label: const Text('Cancel Listing', style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: Colors.redAccent),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Listing is currently ${waste.status.toLowerCase()}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ],
                  ] else ...[
                    // Buyer / Marketplace Visitor Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showContactSellerDialog(context),
                            icon: const Icon(Icons.phone),
                            label: const Text('Contact Seller'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Buy / Make Offer',
                            icon: Icons.shopping_bag_outlined,
                            color: Colors.brown.shade700,
                            onPressed: () => _showBuyEnquiryDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AgroColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AgroColors.textMuted),
        ),
      ],
    );
  }
}
