import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/crop.dart';
import '../../../models/crop_health.dart';
import '../../../services/crop_health_service.dart';
import '../../../widgets/primary_button.dart';

class CheckCropHealthScreen extends StatefulWidget {
  final String? initialCropName;
  final String? initialCropImage;
  final List<Crop>? availableCrops;
  final Function(CropHealthResult result) onCheckResult;
  final VoidCallback? onBack;

  const CheckCropHealthScreen({
    Key? key,
    this.initialCropName,
    this.initialCropImage,
    this.availableCrops,
    required this.onCheckResult,
    this.onBack,
  }) : super(key: key);

  @override
  State<CheckCropHealthScreen> createState() => _CheckCropHealthScreenState();
}

class _CheckCropHealthScreenState extends State<CheckCropHealthScreen> {
  late String _selectedCropName;
  String? _selectedImage;
  String? _selectedConditionHint;
  bool _isAnalyzing = false;
  String? _validationError;

  final CropHealthService _healthService = CropHealthService();

  // Standard regional agricultural crops fallback
  static const List<String> _fallbackCrops = [
    'Tomato',
    'Wheat',
    'Onion',
    'Sugarcane',
    'Cotton',
    'Soybean',
    'Maize',
    'Rice',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCropName != null && widget.initialCropName!.isNotEmpty) {
      _selectedCropName = widget.initialCropName!;
    } else if (widget.availableCrops != null && widget.availableCrops!.isNotEmpty) {
      _selectedCropName = widget.availableCrops!.first.name;
    } else {
      _selectedCropName = 'Tomato';
    }

    // If an initial image is provided, set it as default
    if (widget.initialCropImage != null && widget.initialCropImage!.isNotEmpty) {
      _selectedImage = widget.initialCropImage;
    }
  }

  List<String> get _cropOptions {
    final Set<String> names = {};
    if (widget.availableCrops != null) {
      for (final crop in widget.availableCrops!) {
        names.add(crop.name);
      }
    }
    names.addAll(_fallbackCrops);
    if (!names.contains(_selectedCropName)) {
      names.add(_selectedCropName);
    }
    return names.toList();
  }

  void _simulateCapture(String source) {
    // Pick the blight sample as standard capture demo
    final sample = CropHealthService.sampleFoliageOptions.first;
    setState(() {
      _selectedImage = sample['url'];
      _selectedConditionHint = sample['category'];
      _validationError = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leaf photo captured via $source simulation'),
        duration: const Duration(seconds: 2),
        backgroundColor: AgroColors.primaryDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _selectPresetSample(Map<String, String> sample) {
    setState(() {
      _selectedImage = sample['url'];
      _selectedConditionHint = sample['category'];
      _validationError = null;
    });
  }

  void _runDiagnosis() async {
    setState(() => _validationError = null);

    // Validation
    if (_selectedCropName.trim().isEmpty) {
      setState(() => _validationError = 'Please select a crop to diagnose.');
      return;
    }

    if (_selectedImage == null || _selectedImage!.trim().isEmpty) {
      setState(() => _validationError = 'Please select or capture a crop leaf image before checking health.');
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final result = await _healthService.diagnoseCrop(
        cropName: _selectedCropName,
        imagePath: _selectedImage!,
        conditionHint: _selectedConditionHint,
      );

      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      widget.onCheckResult(result);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _validationError = 'An error occurred during diagnosis. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroColors.background,
      appBar: AppBar(
        title: const Text('Check Crop Health'),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                _buildGuidanceBanner(),
                const SizedBox(height: 16),

                // Validation banner if error
                if (_validationError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _validationError!,
                            style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 1. Select Crop Card
                _buildCropSelectionCard(),
                const SizedBox(height: 16),

                // 2. Crop Image Area
                _buildImagePreviewCard(),
                const SizedBox(height: 16),

                // 3. Leaf Preset Selector
                _buildPresetSelectorCard(),
                const SizedBox(height: 24),

                // 4. Submit / Diagnose Button
                PrimaryButton(
                  label: _isAnalyzing ? 'Analyzing Crop Foliage...' : 'Check Crop Health',
                  icon: Icons.health_and_safety,
                  isLoading: _isAnalyzing,
                  onPressed: _isAnalyzing ? () {} : _runDiagnosis,
                ),
                const SizedBox(height: 16),

                // Safety advice footnote
                const Center(
                  child: Text(
                    'Diagnosis is based on agricultural foliage indicators.\nAlways consult local agricultural officers for severe infections.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AgroColors.textLight, height: 1.4),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuidanceBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal.shade700,
            child: const Icon(Icons.psychology, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Crop Health & Disease Diagnostic',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                ),
                SizedBox(height: 2),
                Text(
                  'Upload or take a clear photo of affected foliage to receive instant disease assessment & safe remedies.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF00695C), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropSelectionCard() {
    final bool hasInitial = widget.initialCropName != null && widget.initialCropName!.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Crop',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                if (hasInitial)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AgroColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'From Crop Details',
                      style: TextStyle(fontSize: 10, color: AgroColors.primaryDark, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCropName,
              items: _cropOptions.map((c) {
                return DropdownMenuItem<String>(
                  value: c,
                  child: Row(
                    children: [
                      const Icon(Icons.eco, size: 18, color: AgroColors.primary),
                      const SizedBox(width: 8),
                      Text(c, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedCropName = val;
                    _validationError = null;
                  });
                }
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crop Foliage Photo',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AgroColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedImage != null ? AgroColors.primary : AgroColors.border,
                  width: _selectedImage != null ? 1.5 : 1,
                ),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AgroColors.surfaceVariant,
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 40, color: AgroColors.textLight),
                              ),
                            ),
                          ),
                          // Condition Tag if preset
                          if (_selectedConditionHint != null)
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _selectedConditionHint!,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          // Remove button
                          Positioned(
                            top: 10,
                            right: 10,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black.withOpacity(0.65),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                    _selectedConditionHint = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AgroColors.surfaceVariant,
                          child: Icon(Icons.add_a_photo_outlined, size: 28, color: AgroColors.textMuted),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No leaf image selected',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Capture foliage with camera or select a sample below',
                          style: TextStyle(fontSize: 12, color: AgroColors.textLight),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _simulateCapture('Camera'),
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('Take Photo'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _simulateCapture('Gallery'),
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: const Text('Choose Photo'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetSelectorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Or Test with Leaf Sample',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
                Text(
                  'Tap to preview condition',
                  style: TextStyle(fontSize: 11, color: AgroColors.textLight),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: CropHealthService.sampleFoliageOptions.map((sample) {
                  final isSelected = _selectedImage == sample['url'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => _selectPresetSample(sample),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? AgroColors.primaryContainer : AgroColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AgroColors.primary : AgroColors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                sample['url']!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sample['label']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                                  ),
                                ),
                                Text(
                                  sample['category']!,
                                  style: const TextStyle(fontSize: 10, color: AgroColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
