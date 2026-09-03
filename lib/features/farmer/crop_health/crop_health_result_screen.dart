import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class CropHealthResultScreen extends StatelessWidget {
  final String cropName;
  final String imagePath;
  final VoidCallback onDone;

  const CropHealthResultScreen({
    Key? key,
    required this.cropName,
    required this.imagePath,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Health Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop photo and diagnosis badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: AgroColors.primaryContainer,
                      child: const Icon(Icons.eco, size: 60, color: AgroColors.primary),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Crop: $cropName',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Health Result Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange.shade900, size: 28),
                      const SizedBox(width: 10),
                      const Text(
                        'Possible Leaf Spot',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Some spots may be affecting the leaves.',
                    style: TextStyle(fontSize: 15, color: Color(0xFFBF360C), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // What You Can Do
            const Text(
              'What You Can Do',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 12),
            _actionItem(Icons.content_cut, 'Remove badly affected leaves', 'Carefully prune and dispose of damaged leaves away from the farm.'),
            _actionItem(Icons.cleaning_services, 'Keep the plants clean', 'Clear any fallen weeds or decaying organic debris around the base.'),
            _actionItem(Icons.water_drop_outlined, 'Avoid too much water on leaves', 'Direct irrigation water to the soil roots rather than wetting the foliage.'),

            const SizedBox(height: 24),

            // Prevention
            const Text(
              'Prevention',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 12),
            _actionItem(Icons.space_bar, 'Keep enough space between plants', 'Ensures adequate airflow and sunlight to keep leaf canopy dry.'),
            _actionItem(Icons.search, 'Check leaves regularly', 'Inspect the underside of leaves every 3 to 4 days during humid weather.'),

            const SizedBox(height: 24),

            // Important Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AgroColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AgroColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: AgroColors.textMuted, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This result is only a guide. For serious problems, ask a farming expert.',
                      style: TextStyle(fontSize: 13, color: AgroColors.textMuted, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            PrimaryButton(
              label: 'Back to Farm',
              icon: Icons.check,
              onPressed: onDone,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _actionItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AgroColors.primaryContainer,
            child: Icon(icon, size: 18, color: AgroColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 13, color: AgroColors.textMuted, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
