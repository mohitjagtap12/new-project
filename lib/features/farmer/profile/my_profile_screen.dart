import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';

class MyProfileScreen extends StatefulWidget {
  final VoidCallback onOpenHelp;

  const MyProfileScreen({
    Key? key,
    required this.onOpenHelp,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String _name = 'Suresh Patil';
  String _phone = '+91 98765 43210';
  String _location = 'Pune, Maharashtra';
  String _farmSize = '5 Acres';
  String _mainCrops = 'Tomato, Wheat, Onion';
  String _selectedLanguage = 'English';

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    final locationCtrl = TextEditingController(text: _location);
    final farmSizeCtrl = TextEditingController(text: _farmSize);
    final cropsCtrl = TextEditingController(text: _mainCrops);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Farmer Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: 10),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
              const SizedBox(height: 10),
              TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'Location')),
              const SizedBox(height: 10),
              TextField(controller: farmSizeCtrl, decoration: const InputDecoration(labelText: 'Farm Size')),
              const SizedBox(height: 10),
              TextField(controller: cropsCtrl, decoration: const InputDecoration(labelText: 'Main Crops')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _name = nameCtrl.text.trim();
                _phone = phoneCtrl.text.trim();
                _location = locationCtrl.text.trim();
                _farmSize = farmSizeCtrl.text.trim();
                _mainCrops = cropsCtrl.text.trim();
              });
              Navigator.of(ctx).pop();
              AppUtils.showSnackBar(context, 'Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Language'),
        content: RadioGroup<String>(
          groupValue: _selectedLanguage,
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedLanguage = val);
              Navigator.of(ctx).pop();
              AppUtils.showSnackBar(context, 'Language set to $_selectedLanguage');
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['English', 'Marathi (मराठी)', 'Hindi (हिन्दी)'].map((lang) {
              return RadioListTile<String>(
                title: Text(lang),
                value: lang.split(' ')[0],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Farmer Avatar & Name Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 46,
                          backgroundColor: AgroColors.primaryContainer,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AgroColors.primary,
                            child: const Icon(Icons.verified, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AgroColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phone,
                      style: const TextStyle(fontSize: 14, color: AgroColors.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AgroColors.primary),
                        const SizedBox(width: 4),
                        Text(_location, style: const TextStyle(fontSize: 14, color: AgroColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Farm Details Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Farm Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                    const Divider(height: 20, color: AgroColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Land Size:', style: TextStyle(color: AgroColors.textLight)),
                        Text(_farmSize, style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.textDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Main Crops Grown:', style: TextStyle(color: AgroColors.textLight)),
                        Text(_mainCrops, style: const TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options List
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_outlined, color: AgroColors.primary),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showEditProfileDialog,
                  ),
                  const Divider(height: 1, color: AgroColors.border),
                  ListTile(
                    leading: const Icon(Icons.language, color: AgroColors.primary),
                    title: const Text('Language'),
                    subtitle: Text(_selectedLanguage, style: const TextStyle(color: AgroColors.primary)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showLanguageDialog,
                  ),
                  const Divider(height: 1, color: AgroColors.border),
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: AgroColors.primary),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: widget.onOpenHelp,
                  ),
                  const Divider(height: 1, color: AgroColors.border),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      AppUtils.showSnackBar(context, 'You are logged in as Demo Farmer');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
