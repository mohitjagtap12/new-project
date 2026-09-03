import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AgroColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'How can we help you?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AgroColors.primaryDark),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Our toll-free helpline and local agricultural advisors are available 7 days a week from 7 AM to 8 PM.',
                    style: TextStyle(fontSize: 13, color: AgroColors.primaryDark, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Call and Message Quick Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppUtils.showSnackBar(context, 'Calling Kisan Toll-Free: 1800-180-1551');
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call Support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AgroColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      AppUtils.showSnackBar(context, 'Opening WhatsApp / Message Support');
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Send Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AgroColors.primary,
                      side: const BorderSide(color: AgroColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Simple FAQs
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AgroColors.textDark),
            ),
            const SizedBox(height: 12),

            _buildFaqItem(
              question: 'How to add my crop?',
              answer: 'Open "My Crops" and tap the "+ Add Crop" button.\nEnter your crop name, farm area, and expected harvest date, then tap Save.',
            ),
            _buildFaqItem(
              question: 'How to sell farm waste?',
              answer: 'Go to "Sell Farm Waste" from the dashboard.\nPick your waste type (like straw or stalks), enter the quantity and price, then tap Post for Sale.',
            ),
            _buildFaqItem(
              question: 'How to find labour?',
              answer: 'Open "Find Labour" from the main menu.\nSelect the type of work you need, pick an available worker near your farm, and tap Request.',
            ),
            _buildFaqItem(
              question: 'How to check crop health?',
              answer: 'Tap "Check Crop Health" on your dashboard.\nTake a clear photo of the damaged leaf to instantly see causes and simple treatment steps.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AgroColors.textDark),
        ),
        iconColor: AgroColors.primary,
        collapsedIconColor: AgroColors.textMuted,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14, color: AgroColors.textMuted, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
