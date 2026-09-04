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
  final VoidCallback? onSellCrop;
  final VoidCallback? onBack;

  const CropDetailsScreen({
    Key? key,
    required this.crop,
    required this.onEditCrop,
    required this.onDeleteCrop,
    required this.onCheckCropHealth,
    this.onSellCrop,
    this.onBack,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Delete Crop',
        message: 'Are you sure you want to remove "${crop.name} (${crop.variety})" from your farm records? This action cannot be undone.',
        confirmLabel: 'Delete Crop',
        cancelLabel: 'Cancel',
        isDestructive: true,
      ),
    );

    if (result == true) {
      onDeleteCrop();
      AppUtils.showSnackBar(context, 'Crop "${crop.name}" deleted successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: AgroColors.surfaceVariant,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: isDesktop ? 24 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (onBack != null)
                          TextButton.icon(
                            onPressed: onBack,
                            icon: const Icon(Icons.arrow_back, size: 20, color: AgroColors.textDark),
                            label: const Text(
                              'Back to My Crops',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AgroColors.textDark,
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: onEditCrop,
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AgroColors.primaryDark,
                                side: const BorderSide(color: AgroColors.primary),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _confirmDelete(context),
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              tooltip: 'Delete Crop',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Main Content: 2 Columns on Desktop, 1 Column on Mobile
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Hero Image & Overview Card
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                _buildImageCard(),
                                const SizedBox(height: 16),
                                _buildActionsCard(context),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right Column: Details & Notes
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                _buildDetailsCard(),
                                if (crop.notes.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  _buildNotesCard(),
                                ],
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildImageCard(),
                          const SizedBox(height: 16),
                          _buildDetailsCard(),
                          if (crop.notes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildNotesCard(),
                          ],
                          const SizedBox(height: 20),
                          _buildActionsCard(context),
                        ],
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            crop.image,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 240,
              width: double.infinity,
              color: AgroColors.primaryContainer,
              child: const Icon(Icons.agriculture, size: 70, color: AgroColors.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AgroColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        crop.variety,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AgroColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: crop.status, fontSize: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crop Specifications',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AgroColors.textDark,
            ),
          ),
          const Divider(height: 24, color: AgroColors.border),

          _buildDetailItem(
            icon: Icons.square_foot,
            label: 'Land / Area',
            value: crop.displayArea,
            color: AgroColors.primary,
          ),
          const SizedBox(height: 14),

          _buildDetailItem(
            icon: Icons.grain,
            label: 'Crop Variety',
            value: crop.variety,
            color: Colors.amber.shade900,
          ),
          const SizedBox(height: 14),

          _buildDetailItem(
            icon: Icons.place_outlined,
            label: 'Location / Village',
            value: crop.location,
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 14),

          _buildDetailItem(
            icon: Icons.calendar_today,
            label: 'Planting Date',
            value: crop.plantingDate,
            color: Colors.indigo.shade700,
          ),
          const SizedBox(height: 14),

          _buildDetailItem(
            icon: Icons.event_available,
            label: 'Expected Harvest Date',
            value: crop.expectedHarvest,
            color: Colors.green.shade800,
          ),
          const SizedBox(height: 14),

          _buildDetailItem(
            icon: Icons.timelapse,
            label: 'Current Status',
            value: crop.status,
            color: Colors.purple.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.notes, size: 20, color: AgroColors.primary),
              SizedBox(width: 8),
              Text(
                'Farmer Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AgroColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AgroColors.border),
            ),
            child: Text(
              crop.notes,
              style: const TextStyle(
                fontSize: 14,
                color: AgroColors.textDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crop Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AgroColors.textDark,
            ),
          ),
          const SizedBox(height: 14),

          // Check Crop Health
          PrimaryButton(
            label: 'Check Crop Health',
            icon: Icons.health_and_safety,
            color: Colors.teal.shade700,
            onPressed: onCheckCropHealth,
          ),
          const SizedBox(height: 10),

          // Sell This Crop (Phase 6)
          if (onSellCrop != null) ...[
            PrimaryButton(
              label: 'Sell This Crop',
              icon: Icons.storefront,
              color: AgroColors.primary,
              onPressed: onSellCrop!,
            ),
            const SizedBox(height: 10),
          ],

          // Edit Crop
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onEditCrop,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Crop Information'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AgroColors.primaryDark,
                side: const BorderSide(color: AgroColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Delete Crop
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
              label: const Text(
                'Delete Crop',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AgroColors.textLight),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AgroColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
