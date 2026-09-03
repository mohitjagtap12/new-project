import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class CheckCropHealthScreen extends StatefulWidget {
  final String? initialCropName;
  final Function(String cropName, String imagePath) onCheckResult;

  const CheckCropHealthScreen({
    Key? key,
    this.initialCropName,
    required this.onCheckResult,
  }) : super(key: key);

  @override
  State<CheckCropHealthScreen> createState() => _CheckCropHealthScreenState();
}

class _CheckCropHealthScreenState extends State<CheckCropHealthScreen> {
  String? _selectedImage;
  late String _cropName;
  bool _isAnalyzing = false;

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _cropName = widget.initialCropName ?? 'Tomato';
  }

  void _simulatePhotoCapture(String source) {
    setState(() {
      _selectedImage = _sampleImages[0];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo selected from $source'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _checkCrop() {
    if (_selectedImage == null) {
      // Auto pick sample photo if user taps check directly
      _selectedImage = _sampleImages[0];
    }

    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      widget.onCheckResult(_cropName, _selectedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Crop Health'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Guidance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal.shade700,
                    child: const Icon(Icons.health_and_safety, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Check Crop Health',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Take a photo of your crop to check for possible problems.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF00695C), height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Select Crop dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Select Crop to Check', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _cropName,
              items: ['Tomato', 'Wheat', 'Onion', 'Sugarcane', 'Maize'].map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) => setState(() => _cropName = val ?? 'Tomato'),
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 24),

            // Image Preview Area
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AgroColors.border, width: 1.5),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(_selectedImage!, fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withValues(alpha: 0.6),
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                onPressed: () => setState(() => _selectedImage = null),
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
                          radius: 34,
                          backgroundColor: AgroColors.surfaceVariant,
                          child: Icon(Icons.camera_alt_outlined, size: 36, color: AgroColors.textMuted),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No photo taken yet',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ensure good light and focus on affected leaves',
                          style: TextStyle(fontSize: 12, color: AgroColors.textLight),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Photo Capture Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _simulatePhotoCapture('Camera'),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AgroColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _simulatePhotoCapture('Gallery'),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose Photo'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AgroColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Check Crop Button
            PrimaryButton(
              label: 'Check Crop',
              icon: Icons.search,
              isLoading: _isAnalyzing,
              onPressed: _checkCrop,
            ),
          ],
        ),
      ),
    );
  }
}
