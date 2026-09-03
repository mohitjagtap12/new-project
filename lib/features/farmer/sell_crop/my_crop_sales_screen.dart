import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';

class MyCropSalesScreen extends StatelessWidget {
  final List<CropSale> sales;
  final VoidCallback onAddNewSale;
  final Function(CropSale) onRemoveSale;
  final Function(CropSale) onEditSale;

  const MyCropSalesScreen({
    Key? key,
    required this.sales,
    required this.onAddNewSale,
    required this.onRemoveSale,
    required this.onEditSale,
  }) : super(key: key);

  void _confirmDelete(BuildContext context, CropSale sale) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Remove Listing',
        message: 'Are you sure you want to remove your sale listing for ${sale.cropName}?',
        confirmLabel: 'Remove',
        cancelLabel: 'Cancel',
        isDestructive: true,
      ),
    );

    if (result == true) {
      onRemoveSale(sale);
      AppUtils.showSnackBar(context, 'Sale listing removed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crop Sales'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: onAddNewSale,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('+ Sell Crop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AgroColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: sales.isEmpty
          ? EmptyStateWidget(
              title: 'No sales posted yet.',
              description: 'Post your farm harvest to connect with direct retail and wholesale buyers.',
              icon: Icons.sell_outlined,
              buttonText: '+ Add Crop for Sale',
              onButtonPressed: onAddNewSale,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final item = sales[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 70,
                                  height: 70,
                                  color: AgroColors.primaryContainer,
                                  child: const Icon(Icons.eco, color: AgroColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.cropName,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                      ),
                                      StatusBadge(status: item.status),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} ${item.unit} • ₹${item.price.toStringAsFixed(0)}/${item.unit}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AgroColors.primary),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: AgroColors.textLight),
                                      const SizedBox(width: 4),
                                      Text(item.location, style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (item.description.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            item.description,
                            style: const TextStyle(fontSize: 13, color: AgroColors.textMuted),
                          ),
                        ],
                        const Divider(height: 24, color: AgroColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => _confirmDelete(context, item),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                minimumSize: const Size(0, 36),
                              ),
                              child: const Text('Remove'),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () => onEditSale(item),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                minimumSize: const Size(0, 36),
                              ),
                              child: const Text('Edit'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (ctx) => Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${item.cropName} Sale Details', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 12),
                                        Text('Quantity: ${item.quantity} ${item.unit}', style: const TextStyle(fontSize: 16)),
                                        Text('Price: ₹${item.price.toStringAsFixed(0)}/${item.unit}', style: const TextStyle(fontSize: 16)),
                                        Text('Location: ${item.location}', style: const TextStyle(fontSize: 16)),
                                        Text('Status: ${item.status}', style: const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AgroColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                minimumSize: const Size(0, 36),
                              ),
                              child: const Text('View'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
