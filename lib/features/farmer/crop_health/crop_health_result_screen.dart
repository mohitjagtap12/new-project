import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/crop_health.dart';
import '../../../widgets/primary_button.dart';

class CropHealthResultScreen extends StatelessWidget {
  final CropHealthResult result;
  final VoidCallback onBackToCropDetails;
  final VoidCallback onCheckAgain;
  final VoidCallback? onBackToDashboard;

  const CropHealthResultScreen({
    Key? key,
    required this.result,
    required this.onBackToCropDetails,
    required this.onCheckAgain,
    this.onBackToDashboard,
  }) : super(key: key);

  Color _getStatusPrimaryColor() {
    if (result.isHealthy) {
      return AgroColors.primary;
    }
    switch (result.status) {
      case 'Fungal Infection':
        return Colors.purple.shade700;
      case 'Pest Damage':
        return Colors.deepOrange.shade800;
      case 'Leaf Disease':
      default:
        return const Color(0xFFE65100);
    }
  }

  Color _getStatusBgColor() {
    if (result.isHealthy) {
      return const Color(0xFFE8F5E9);
    }
    switch (result.status) {
      case 'Fungal Infection':
        return const Color(0xFFF3E5F5);
      case 'Pest Damage':
        return const Color(0xFFFBE9E7);
      case 'Leaf Disease':
      default:
        return const Color(0xFFFFF3E0);
    }
  }

  IconData _getStatusIcon() {
    if (result.isHealthy) {
      return Icons.verified;
    }
    switch (result.status) {
      case 'Fungal Infection':
        return Icons.coronavirus_outlined;
      case 'Pest Damage':
        return Icons.pest_control;
      case 'Leaf Disease':
      default:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusPrimaryColor();
    final statusBg = _getStatusBgColor();

    return Scaffold(
      backgroundColor: AgroColors.background,
      appBar: AppBar(
        title: const Text('Crop Health Diagnosis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToCropDetails,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Crop Foliage Photo & Header Badge
                _buildPhotoHero(statusColor),
                const SizedBox(height: 16),

                // 2. Health Status & Disease Card
                _buildDiagnosisStatusCard(statusColor, statusBg),
                const SizedBox(height: 16),

                // 3. Observed Symptoms
                _buildSymptomsCard(),
                const SizedBox(height: 16),

                // 4. Recommended Treatments / Actions
                _buildActionCard(
                  title: 'Recommended Agronomic Actions',
                  subtitle: 'Safe, biological and cultural remedies for recovery',
                  icon: Icons.healing,
                  actions: result.recommendedActions,
                ),
                const SizedBox(height: 16),

                // 5. Prevention & Field Management Tips
                _buildActionCard(
                  title: 'Prevention & Field Management',
                  subtitle: 'Good agricultural practices to protect future yields',
                  icon: Icons.shield_outlined,
                  actions: result.preventionTips,
                ),
                const SizedBox(height: 16),

                // 6. Agricultural Advisory Footnote
                _buildAdvisoryNotice(),
                const SizedBox(height: 24),

                // 7. Navigation Action Buttons
                PrimaryButton(
                  label: 'Back to Crop Details',
                  icon: Icons.arrow_back,
                  onPressed: onBackToCropDetails,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onCheckAgain,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check Another Leaf / Crop'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AgroColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                if (onBackToDashboard != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onBackToDashboard,
                    child: const Text('Return to Farmer Dashboard', style: TextStyle(color: AgroColors.textMuted)),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoHero(Color statusColor) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AgroColors.border),
      ),
      child: Stack(
        children: [
          Image.network(
            result.imagePath,
            height: 210,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 210,
              color: AgroColors.surfaceVariant,
              child: const Center(
                child: Icon(Icons.eco, size: 64, color: AgroColors.primary),
              ),
            ),
          ),
          // Top Crop Name Tag
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Crop: ${result.cropName}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Confidence Tag
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.92),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.insights, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${result.formattedConfidence} Confidence',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisStatusCard(Color statusColor, Color statusBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: statusColor,
                child: Icon(_getStatusIcon(), color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        result.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.diseaseName,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Diagnostic Confidence Bar
          Row(
            children: [
              Text(
                'Diagnostic Match:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: result.confidence,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                result.formattedConfidence,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.checklist, color: AgroColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Observed Symptoms',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: result.symptoms.map((symptom) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4, right: 10),
                        child: Icon(Icons.fiber_manual_record, size: 8, color: AgroColors.primary),
                      ),
                      Expanded(
                        child: Text(
                          symptom,
                          style: const TextStyle(fontSize: 13, color: AgroColors.textDark, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<DiagnosisAction> actions,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AgroColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AgroColors.textLight)),
            const SizedBox(height: 14),
            Column(
              children: actions.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AgroColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AgroColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AgroColors.primaryContainer,
                          child: const Icon(Icons.check, size: 16, color: AgroColors.primaryDark),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                action.description,
                                style: const TextStyle(fontSize: 12, color: AgroColors.textMuted, height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AgroColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: AgroColors.textMuted, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Diagnostic Advisory: This guidance is intended as an educational field support tool. For high-severity infections or large commercial acreage, consult your nearest Krishi Vigyan Kendra (KVK) or certified agricultural university extension officer.',
              style: TextStyle(fontSize: 12, color: AgroColors.textMuted, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
