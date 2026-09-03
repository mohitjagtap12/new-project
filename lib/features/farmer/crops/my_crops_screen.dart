import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/crop.dart';
import '../../../widgets/crop_card.dart';
import '../../../widgets/empty_state.dart';

class MyCropsScreen extends StatelessWidget {
  final List<Crop> crops;
  final VoidCallback onAddCrop;
  final Function(Crop) onViewCrop;
  final Function(Crop) onEditCrop;

  const MyCropsScreen({
    Key? key,
    required this.crops,
    required this.onAddCrop,
    required this.onViewCrop,
    required this.onEditCrop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crops'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: onAddCrop,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('+ Add Crop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AgroColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: crops.isEmpty
          ? EmptyStateWidget(
              title: 'No crops added yet.',
              description: 'Record your crops to track planting, growth, and harvest schedules.',
              icon: Icons.agriculture_outlined,
              buttonText: '+ Add Crop',
              onButtonPressed: onAddCrop,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return CropCard(
                  crop: crop,
                  onView: () => onViewCrop(crop),
                  onEdit: () => onEditCrop(crop),
                );
              },
            ),
    );
  }
}
