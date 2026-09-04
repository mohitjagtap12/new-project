import '../models/crop_health.dart';

/// Service responsible for analyzing crop foliage and identifying crop health issues.
/// Currently implements an agronomic mock diagnosis engine with realistic conditions.
/// This architecture allows seamless replacement with on-device TensorFlow Lite / ONNX
/// models or a backend ML service in future phases without touching the UI layer.
class CropHealthService {
  static final CropHealthService _instance = CropHealthService._internal();
  factory CropHealthService() => _instance;
  CropHealthService._internal();

  /// Preset sample images representing different leaf conditions for testing
  static const List<Map<String, String>> sampleFoliageOptions = [
    {
      'label': 'Blight / Leaf Spot',
      'category': 'Leaf Disease',
      'url': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
    {
      'label': 'Fungal Mildew',
      'category': 'Fungal Infection',
      'url': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      'label': 'Pest Holes / Miner',
      'category': 'Pest Damage',
      'url': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    },
    {
      'label': 'Healthy Green Leaf',
      'category': 'Healthy Crop',
      'url': 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?w=600&auto=format&fit=crop&q=80',
    },
  ];

  /// Simulates ML diagnosis inference with realistic agronomic advisory
  Future<CropHealthResult> diagnoseCrop({
    required String cropName,
    required String imagePath,
    String? conditionHint,
  }) async {
    // Simulate inference latency
    await Future.delayed(const Duration(milliseconds: 1400));

    final normalizedCrop = cropName.toLowerCase().trim();
    final hint = conditionHint?.toLowerCase() ?? '';

    // Determine diagnosis condition
    if (hint.contains('healthy') || imagePath.contains('1543083477-4f785aeafaa9')) {
      return _buildHealthyResult(cropName, imagePath);
    } else if (hint.contains('fungal') || hint.contains('mildew') || imagePath.contains('1574323347407')) {
      return _buildFungalResult(cropName, normalizedCrop, imagePath);
    } else if (hint.contains('pest') || hint.contains('insect') || imagePath.contains('1618512496248')) {
      return _buildPestResult(cropName, normalizedCrop, imagePath);
    } else {
      // Default to leaf disease / blight
      return _buildLeafDiseaseResult(cropName, normalizedCrop, imagePath);
    }
  }

  CropHealthResult _buildHealthyResult(String cropName, String imagePath) {
    return CropHealthResult(
      id: 'diag_${DateTime.now().millisecondsSinceEpoch}',
      cropName: cropName,
      imagePath: imagePath,
      status: 'Healthy Crop',
      isHealthy: true,
      diseaseName: 'Healthy & Disease-Free Foliage',
      confidence: 0.96,
      symptoms: [
        'Vibrant, uniform green leaf pigmentation without chlorosis',
        'Intact leaf margin and cuticle with no visible necrotic spots',
        'Normal photosynthetic vigor and firm cellular structure',
        'No signs of fungal mycelium, bacterial ooze, or pest puncture holes',
      ],
      recommendedActions: const [
        DiagnosisAction(
          title: 'Maintain Regular Irrigation Routine',
          description: 'Keep soil moisture consistent based on crop growth stage; avoid waterlogging roots.',
        ),
        DiagnosisAction(
          title: 'Balanced Nutrition',
          description: 'Apply balanced organic compost or recommended micronutrient spray according to soil test.',
        ),
        DiagnosisAction(
          title: 'Foliar Monitoring',
          description: 'Inspect the lower foliage once a week during humid or overcast morning periods.',
        ),
      ],
      preventionTips: const [
        DiagnosisAction(
          title: 'Crop Sanitation',
          description: 'Keep the inter-row pathways weed-free to avoid sheltering secondary insect pests.',
        ),
        DiagnosisAction(
          title: 'Prophylactic Bio-Sprays',
          description: 'Periodic spray of diluted Panchagavya or bio-fertilizers keeps leaf immunity strong.',
        ),
      ],
    );
  }

  CropHealthResult _buildLeafDiseaseResult(String cropName, String normalizedCrop, String imagePath) {
    String disease = 'Early Leaf Blight';
    if (normalizedCrop.contains('tomato')) {
      disease = 'Tomato Early Blight (Alternaria solani)';
    } else if (normalizedCrop.contains('onion')) {
      disease = 'Purple Blotch (Alternaria porri)';
    } else if (normalizedCrop.contains('wheat')) {
      disease = 'Spot Blotch (Bipolaris sorokiniana)';
    } else if (normalizedCrop.contains('cotton')) {
      disease = 'Alternaria Leaf Spot';
    }

    return CropHealthResult(
      id: 'diag_${DateTime.now().millisecondsSinceEpoch}',
      cropName: cropName,
      imagePath: imagePath,
      status: 'Leaf Disease',
      isHealthy: false,
      diseaseName: disease,
      confidence: 0.92,
      symptoms: [
        'Concentric target-like brown to dark spots on older leaves',
        'Yellowish chlorotic halos developing around leaf spots',
        'Premature drying and defoliation of lower canopy leaves',
        'Progressive leaf edge curling under humid weather conditions',
      ],
      recommendedActions: const [
        DiagnosisAction(
          title: 'Prune & Remove Infected Leaves',
          description: 'Gently clip off severely spotted bottom leaves and burn or bury them away from the field.',
        ),
        DiagnosisAction(
          title: 'Avoid Overhead Sprinkler Irrigation',
          description: 'Switch to drip or furrow irrigation to keep foliage dry and arrest spore germination.',
        ),
        DiagnosisAction(
          title: 'Organic Bio-Fungicide Treatment',
          description: 'Apply Trichoderma viride bio-spray or 0.5% neem seed kernel extract early morning.',
        ),
      ],
      preventionTips: const [
        DiagnosisAction(
          title: 'Ensure Wide Canopy Spacing',
          description: 'Follow recommended row-to-row spacing to allow rapid drying of morning dew.',
        ),
        DiagnosisAction(
          title: 'Crop Rotation with Legumes',
          description: 'Do not plant solanaceous crops in the same plot consecutively to break pathogen cycles.',
        ),
      ],
    );
  }

  CropHealthResult _buildFungalResult(String cropName, String normalizedCrop, String imagePath) {
    String disease = 'Powdery Mildew';
    if (normalizedCrop.contains('wheat')) {
      disease = 'Yellow Rust (Puccinia striiformis)';
    } else if (normalizedCrop.contains('sugarcane')) {
      disease = 'Red Rot (Colletotrichum falcatum)';
    } else if (normalizedCrop.contains('soybean')) {
      disease = 'Soybean Rust (Phakopsora pachyrhizi)';
    }

    return CropHealthResult(
      id: 'diag_${DateTime.now().millisecondsSinceEpoch}',
      cropName: cropName,
      imagePath: imagePath,
      status: 'Fungal Infection',
      isHealthy: false,
      diseaseName: disease,
      confidence: 0.89,
      symptoms: [
        'White or grayish powdery fungal patches on upper and lower leaf surfaces',
        'Leaves turn brittle, distorted, and dry prematurely',
        'Impaired photosynthesis causing stunted plant vigor and reduced fruit sizing',
        'Powdery fungal residue easily rubs off on fingertips',
      ],
      recommendedActions: const [
        DiagnosisAction(
          title: 'Improve Canopy Aeration',
          description: 'Thin out crowded vegetative shoots to promote direct sunlight and air penetration.',
        ),
        DiagnosisAction(
          title: 'Apply Wettable Sulfur / Bio-Spray',
          description: 'Spray mild wettable sulfur or Bacillus subtilis bio-formulation across affected areas.',
        ),
        DiagnosisAction(
          title: 'Disinfect Pruning Tools',
          description: 'Clean garden shears in a mild disinfectant between handling affected and healthy plants.',
        ),
      ],
      preventionTips: const [
        DiagnosisAction(
          title: 'Avoid Excessive Nitrogen Fertilizer',
          description: 'Excess nitrogen produces lush, tender leaf growth that is highly vulnerable to fungal spores.',
        ),
        DiagnosisAction(
          title: 'Morning Irrigation Only',
          description: 'Irrigate only early in the day so remaining soil moisture evaporates before nightfall.',
        ),
      ],
    );
  }

  CropHealthResult _buildPestResult(String cropName, String normalizedCrop, String imagePath) {
    String pest = 'Leaf Miner & Piercing Aphids';
    if (normalizedCrop.contains('maize') || normalizedCrop.contains('cotton')) {
      pest = 'Fall Armyworm (Spodoptera frugiperda)';
    } else if (normalizedCrop.contains('sugarcane')) {
      pest = 'Top Borer (Scirpophaga excerptalis)';
    } else if (normalizedCrop.contains('onion')) {
      pest = 'Onion Thrips (Thrips tabaci)';
    }

    return CropHealthResult(
      id: 'diag_${DateTime.now().millisecondsSinceEpoch}',
      cropName: cropName,
      imagePath: imagePath,
      status: 'Pest Damage',
      isHealthy: false,
      diseaseName: pest,
      confidence: 0.94,
      symptoms: [
        'Irregular serpentine winding tunnels carved inside leaf tissue',
        'Shot-hole punctures and ragged leaf margins caused by chewing larvae',
        'Leaf curling, honeydew excretion, and sooty mold along leaf veins',
        'Visible cluster of small nymph insects on the underside of young foliage',
      ],
      recommendedActions: const [
        DiagnosisAction(
          title: 'Install Sticky Pheromone Traps',
          description: 'Place yellow and blue sticky traps (5-6 per acre) to trap flying adult insect vectors.',
        ),
        DiagnosisAction(
          title: 'Organic Neem Oil Spray',
          description: 'Spray 10,000 ppm cold-pressed neem oil (5 ml per litre of water with mild soap) at dusk.',
        ),
        DiagnosisAction(
          title: 'Manual Removal of Larvae',
          description: 'For localized outbreaks, manually hand-pick egg masses and visible caterpillar clusters.',
        ),
      ],
      preventionTips: const [
        DiagnosisAction(
          title: 'Border Trap Crops',
          description: 'Plant marigold or castor around the plot boundary to attract pests away from main crops.',
        ),
        DiagnosisAction(
          title: 'Encourage Natural Predators',
          description: 'Ladybird beetles and lacewings act as natural biological controls against aphids and thrips.',
        ),
      ],
    );
  }
}
