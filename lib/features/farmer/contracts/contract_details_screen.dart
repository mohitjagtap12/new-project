import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/contract.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class ContractDetailsScreen extends StatefulWidget {
  final FarmContract contract;
  final Function(FarmContract) onApply;

  const ContractDetailsScreen({
    Key? key,
    required this.contract,
    required this.onApply,
  }) : super(key: key);

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  late FarmContract _currentContract;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _currentContract = widget.contract;
  }

  void _applyContract() {
    setState(() => _isApplying = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final updated = _currentContract.copyWith(status: 'Under Review');
      setState(() {
        _currentContract = updated;
        _isApplying = false;
      });
      widget.onApply(updated);
      AppUtils.showSnackBar(context, 'Application sent');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = _currentContract;
    final isAlreadyApplied = c.status != 'Available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AgroColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c.company,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                        ),
                      ),
                      StatusBadge(status: c.status, fontSize: 13),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AgroColors.textLight),
                      const SizedBox(width: 4),
                      Text(c.location, style: const TextStyle(fontSize: 14, color: AgroColors.textMuted)),
                      const Spacer(),
                      const Icon(Icons.event, size: 16, color: AgroColors.textLight),
                      const SizedBox(width: 4),
                      Text('Last Date: ${c.lastDate}', style: const TextStyle(fontSize: 14, color: AgroColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Agreement terms
            const Text('Contract Requirements', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
            const SizedBox(height: 12),
            _infoTile(Icons.eco, 'Crop Name', c.crop),
            _infoTile(Icons.scale, 'Target Quantity', c.quantity),
            _infoTile(Icons.currency_rupee, 'Agreed Price', '₹${c.price.toStringAsFixed(0)} / kg (Guaranteed Minimum)'),
            _infoTile(Icons.verified, 'Quality Standards', c.quality),
            _infoTile(Icons.date_range, 'Contract Period', c.contractPeriod),

            const SizedBox(height: 20),

            // Company Profile Section
            const Text('Company Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AgroColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                c.companyDetails,
                style: const TextStyle(fontSize: 14, color: AgroColors.textMuted, height: 1.4),
              ),
            ),
            const SizedBox(height: 32),

            // Apply Button
            PrimaryButton(
              label: isAlreadyApplied ? 'Application: ${c.status}' : 'Apply for Contract',
              icon: isAlreadyApplied ? Icons.check : Icons.send,
              isLoading: _isApplying,
              color: isAlreadyApplied ? Colors.grey.shade700 : AgroColors.primary,
              onPressed: isAlreadyApplied ? null : _applyContract,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String val) {
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
                Text(label, style: const TextStyle(fontSize: 12, color: AgroColors.textLight)),
                const SizedBox(height: 2),
                Text(val, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
