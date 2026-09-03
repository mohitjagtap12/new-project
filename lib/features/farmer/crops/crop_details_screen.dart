import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/crop.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class CropDetailsScreen extends StatelessWidget {
  final Crop crop;
  final VoidCallback onEditCrop;
  final VoidCallback onDeleteCrop;
  final VoidCallback onCheckCropHealth;

  const CropDetailsScreen({
    Key? key,
    required this.crop,
    required this.onEditCrop,
    required this.onDeleteCrop,
    required this.onCheckCropHealth,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const ConfirmationDialog(
        title: 'Delete Crop',
        message: 'Are you sure you want to remove this crop from your farm records?',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
        isDestructive: true,
      ),
    );

    if (result == true) {
      onDeleteCrop();
      AppUtils.showSnackBar(context, 'Crop removed from records');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Hero Photo
            Image.network(
              crop.image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: AgroColors.primaryContainer,
                child: const Icon(Icons.agriculture, size: 70, color: AgroColors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          crop.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AgroColors.textDark),
                        ),
                      ),
                      StatusBadge(status: crop.status, fontSize: 13),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    crop.variety,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AgroColors.textMuted),
                  ),
                  const Divider(height: 32, color: AgroColors.border),

                  // Detail Grid
                  _buildDetailRow(Icons.landscape, 'Farm Area', crop.area),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.calendar_today, 'Planting Date', crop.plantingDate),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.event_available, 'Expected Harvest', crop.expectedHarvest),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.timelapse, 'Current Status', crop.status),

                  if (crop.notes.isNotEmpty) ...[
                    const Divider(height: 32, color: AgroColors.border),
                    const Text(
                      'Farmer Notes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AgroColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        crop.notes,
                        style: const TextStyle(fontSize: 14, color: AgroColors.textMuted, height: 1.4),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Action Buttons
                  PrimaryButton(
                    label: 'Check Crop Health',
                    icon: Icons.health_and_safety,
                    color: Colors.teal.shade700,
                    onPressed: onCheckCropHealth,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Edit Crop',
                    icon: Icons.edit,
                    isOutlined: true,
                    onPressed: onEditCrop,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton.icon(
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Delete Crop',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AgroColors.primaryContainer,
          child: Icon(icon, color: AgroColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AgroColors.textLight)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AgroColors.textDark)),
          ],
        ),
      ],
    );
  }
}
