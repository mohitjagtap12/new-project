class DiagnosisAction {
  final String title;
  final String description;

  const DiagnosisAction({
    required this.title,
    required this.description,
  });
}

class CropHealthResult {
  final String id;
  final String cropName;
  final String imagePath;
  final String status; // 'Healthy Crop', 'Leaf Disease', 'Fungal Infection', 'Pest Damage'
  final bool isHealthy;
  final String diseaseName;
  final double confidence; // e.g. 0.94 for 94%
  final List<String> symptoms;
  final List<DiagnosisAction> recommendedActions;
  final List<DiagnosisAction> preventionTips;
  final DateTime diagnosedAt;

  CropHealthResult({
    required this.id,
    required this.cropName,
    required this.imagePath,
    required this.status,
    required this.isHealthy,
    required this.diseaseName,
    required this.confidence,
    required this.symptoms,
    required this.recommendedActions,
    required this.preventionTips,
    DateTime? diagnosedAt,
  }) : diagnosedAt = diagnosedAt ?? DateTime.now();

  String get formattedConfidence => '${(confidence * 100).toInt()}%';
}
