import 'package:flutter/material.dart';
import '../../../models/contract.dart';
import '../../../widgets/contract_card.dart';

class FarmContractsScreen extends StatelessWidget {
  final List<FarmContract> contracts;
  final Function(FarmContract) onViewContract;

  const FarmContractsScreen({
    Key? key,
    required this.contracts,
    required this.onViewContract,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Contracts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade700,
                    child: const Icon(Icons.handshake, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Farm Contracts',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF311B92)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Find companies that want to buy your crop.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF4527A0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ...contracts.map((contract) => ContractCard(
                  contract: contract,
                  onView: () => onViewContract(contract),
                )),
          ],
        ),
      ),
    );
  }
}
